class Course < ActiveRecord::Base
	belongs_to :race
	has_many :segments
end
