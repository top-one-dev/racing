class StageEffort < ActiveRecord::Base
  belongs_to :stage
  belongs_to :cyclist
end
