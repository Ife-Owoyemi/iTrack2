class Option < ActiveRecord::Base
  attr_accessible :opreq_id, :cgoal, :hgoal, :optionname, :ocourses_attributes
  belongs_to :opreq
  belongs_to :group
  has_many :ocourses, dependent: :destroy
  accepts_nested_attributes_for :ocourses, :allow_destroy => true

end
