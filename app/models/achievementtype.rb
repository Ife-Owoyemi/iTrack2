class Achievementtype < ActiveRecord::Base
  belongs_to :instituition
  attr_accessible :institution_id, :achievementtype,  :colleges_attributes
  has_many :colleges, dependent: :destroy

  accepts_nested_attributes_for :colleges, :allow_destroy => true
end
