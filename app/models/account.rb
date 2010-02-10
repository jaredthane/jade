class Account < ActiveRecord::Base
	has_many :entries, :dependent => :destroy
	belongs_to :parent, :class_name => "Account"
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	
	CREDIT = -1
	DEBIT = 1
	
	#################################################################################################
	# Searches for Account, if it doesnt exist it creates it and returns it
	#################################################################################################
	def self.find_by_name_or_create(arg)
		find_by_name(arg[:name]) || create(arg)
	end
	
	#################################################################################################
	# Search by account name and optionally filter by child and parent
	#################################################################################################
	def self.search(search, filter = '', page=nil)
		c = "(accounts.name like '%#{search}%')"
		o = 'accounts.number'
		logger.debug "filter=#{filter.to_s}"
		case filter
		when 'parent'
			c += ' AND is_parent=1'
		when 'child'
			c += ' AND is_parent=0'
		end
		if page
  		paginate :per_page => 20, :page => page, :conditions => c, :order => o
  	else
  		find :all, :conditions => c, :order => o
  	end
	end
	
	#################################################################################################
	# Returns list of all immediate children of this account
	#################################################################################################
	def children
	  return Account.find_all_by_parent_id(self.id)
	end	
	
	#################################################################################################
	# Returns a list of all descendants of this account
	#################################################################################################
	def all_children
		list=Account.find_all_by_parent_id(self.id)
	  for child in list
	  	list +=child.all_children
	  end
	  return list
	end
	
	#################################################################################################
	# Returns balance of account
	#################################################################################################
	def balance
		if is_parent
			list = all_children.collect{|c| c.id.to_s + ", "}.to_s.chop.chop
			if list.length > 0
				return Entry.sum('value * multiplier', :conditions=>"account_id in (#{list})") * self.modifier
			else
				return 0
			end
		else
			if Entry.count(:conditions=>"account_id=#{self.id}") > 0
				sum = Entry.sum('value * multiplier', :conditions=>"account_id = #{self.id}").to_d
				return sum * self.modifier
			end
			return 0
		end
	end
	
	##############################################################
	# Validates de model
	##############################################################
	def validate
    errors.add "Nombre","no es válido" if !name or name==''
    if self.new_record?
    	errors.add "Nombre ","debe ser único" if Account.find(:first,:conditions=> "name = '#{name}'")
    end		
	end # def validate
	
	##############################################################
	# Creates a Transaction that will transfer the balance of an account to another
	##############################################################
	def transfer_balance_to(account)
		BalanceTransfer.create_simple_accounting_transaction(:from=>self, :to=>account, :value=>self.balance)
	end # def transfer_balance_to
		
	#################################################################################################
	# Checks to be sure all accounting balances
	#################################################################################################
	def self.check
		return Entry.sum('value * multiplier').to_d
	end
	
	#################################################################################################
	# Checks to be sure each transaction balances
	#################################################################################################
	def self.thourough_check
		sql = ActiveRecord::Base.connection()
		query='select count(id) count from (select movements.id, sum(value*multiplier) sum from entries inner join movements on movements.id=entries.movement_id group by movements.id) as movements where sum!=0'
		return sql.execute(query).fetch_hash["count"].to_f
	end
	
	#################################################################################################
	# Makes urls show name as well as id, you can still us just the id if you want
	#################################################################################################
	def to_param
    "#{id}-#{name.parameterize}"
  end
end
