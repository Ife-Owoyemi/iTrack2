class Transfer < ActiveRecord::Base
  attr_accessible :user_id, :usercourses_attributes
  belongs_to :user
  has_many :usercourses
  accepts_nested_attributes_for :usercourses, :allow_destroy => true
end
