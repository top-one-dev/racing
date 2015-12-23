class Cyclist < ActiveRecord::Base
	default_scope {order('id DESC')}

	has_many :rosters	
	has_many :races, through: :rosters
end
