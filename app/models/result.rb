class Result < ActiveRecord::Base
	belongs_to :race
	belongs_to :course
	belongs_to :segment
	belongs_to :cyclist
end
