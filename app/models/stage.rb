class Stage < ActiveRecord::Base
  default_scope {order('stage_no')}
  validates :stage_no, uniqueness: {scope: :race_id, message: "Stage number should be unique per race"}
  validates :stage_no, presence: true

  belongs_to :race
  has_many :segments, dependent: :destroy	
  has_many :stage_efforts, dependent: :destroy
end