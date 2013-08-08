class Groupopreq < ActiveRecord::Base
  attr_accessible :ggoal, :groupopreqname, :specialty_id, :groups_attributes
  belongs_to :specialty
  has_many :groups, dependent: :destroy
  accepts_nested_attributes_for :groups, :allow_destroy => true
end
