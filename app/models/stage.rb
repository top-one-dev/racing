class Stage < ActiveRecord::Base
  belongs_to :race
  has_many :segments, dependent: :destroy	
  has_many :stage_efforts, dependent: :destroy
end
