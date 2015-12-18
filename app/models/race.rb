class Race < ActiveRecord::Base	
	has_many :courses
	has_many :rosters
end
