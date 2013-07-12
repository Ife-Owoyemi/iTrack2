class Semester < ActiveRecord::Base
  attr_accessible :semester, :usercourses_attributes
  belongs_to :year
  has_many :usercourses
  accepts_nested_attributes_for :usercourses, :allow_destroy => true
end
