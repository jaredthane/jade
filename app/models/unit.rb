class Unit < ActiveRecord::Base
def self.search(search, page)
	paginate :per_page => 20, :page => page,
	         :conditions => ['units.name like :search', {:search => "%#{search}%"}],
	         :order => 'name'
	end
end
