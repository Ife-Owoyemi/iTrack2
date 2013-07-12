class Achievementname < ActiveRecord::Base
  attr_accessible :college_id,:achievementname, :hourreq, :specialties_attributes
  belongs_to :college
  has_many :specialties, dependent: :destroy
  accepts_nested_attributes_for :specialties, :allow_destroy => true
end