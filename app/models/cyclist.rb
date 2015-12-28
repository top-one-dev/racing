class Cyclist < ActiveRecord::Base
	default_scope {order('id')}

	has_many :stage_efforts, dependent: :destroy	
	has_many :rosters, dependent: :destroy	
	has_many :races, through: :rosters
end
