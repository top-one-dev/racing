class Cyclist < ActiveRecord::Base
	has_many :rosters	
	has_many :races, through: :rosters
end
