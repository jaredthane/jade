class Account < ActiveRecord::Base
	has_many :entries, :dependent => :destroy
	belongs_to :parent, :class_name => "Account"
	belongs_to :blocker, :class_name => "User", :foreign_key => 'blocked_by'
	
	##################################################################################################
	# Checks to be sure all accounting balances
	#################################################################################################
	def self.check
		sql = ActiveRecord::Base.connection()
		query='select sum(value*post_type_id) sum from posts'
		return sql.execute(query).fetch_hash["sum"].to_f
	end
	
	##################################################################################################
	# Checks to be sure each transaction balances
	#################################################################################################
	def self.thourough_check
		sql = ActiveRecord::Base.connection()
		query='select count(id) count from (select trans.id, sum(value*post_type_id) sum from posts inner join trans on trans.id=posts.trans_id group by trans.id) as trans where sum!=0'
		return sql.execute(query).fetch_hash["count"].to_f
	end
	def to_param
    "#{id}-#{name.parameterize}"
  end
	CREDIT = -1
	DEBIT = 1
	##################################################################################################
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
	##################################################################################################
	# Returns list of all immediate children of this account
	#################################################################################################
	def children
	  return Account.find_all_by_parent_id(self.id)
	end	
	##################################################################################################
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
				return Entry.sum('value*multiplier', :conditions=>"account_id in (#{list})") * self.modifier
			else
				return 0
			end
		else
			return Entry.sum('value*multiplier', :conditions=>"account_id = #{self.id}") * self.modifier
		end
	end
end
