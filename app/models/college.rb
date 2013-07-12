class College < ActiveRecord::Base
  attr_accessible :achievementtype_id, :college, :achievementnames_attributes
  belongs_to :achievementtype
  has_many :achievementnames, dependent: :destroy
  accepts_nested_attributes_for :achievementnames, :allow_destroy => true
end
