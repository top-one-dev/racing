class SegmentEffort < ActiveRecord::Base
  belongs_to :segment
  belongs_to :stage_effort
end
