class Depnumreq < ActiveRecord::Base
  attr_accessible :cgoal, :depnumreqname, :hgoal, :doublecount, :specialty_id, :deps_attributes
  belongs_to :specialty
  has_many :deps, dependent: :destroy
  accepts_nested_attributes_for :deps, :allow_destroy => true
end
