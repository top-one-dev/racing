class Stage < ActiveRecord::Base
  default_scope {order('stage_no')}

  belongs_to :race
  has_many :segments, dependent: :destroy	
  has_many :stage_efforts, dependent: :destroy
end