class Participant < ActiveRecord::Base
	belongs_to :race
	belongs_to :cyclist
end
