class Corereq < ActiveRecord::Base
  attr_accessible :specialty_id, :corereqname, :cgoal, :hgoal, :ccourses_attributes
  belongs_to :specialty
  has_many :ccourses, dependent: :destroy
  accepts_nested_attributes_for :ccourses, :allow_destroy => true

end
