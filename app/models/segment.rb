class Segment < ActiveRecord::Base
  default_scope {order('id')}
  belongs_to :stage
end
