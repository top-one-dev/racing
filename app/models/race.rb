class Race < ActiveRecord::Base	
	has_many :courses
	#has_many :rosters
	#accepts_nested_attributes_for :courses
end
