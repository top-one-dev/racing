class Race < ActiveRecord::Base
	default_scope {order('id DESC')}

	has_many :rosters
	has_many :cyclists, through: :rosters
	has_many :stages

	accepts_nested_attributes_for :cyclists #, :allow_destroy =>true
	accepts_nested_attributes_for :rosters, :allow_destroy =>true
end
