class Stage < ActiveRecord::Base
  belongs_to :race
  has_many :segments
end
