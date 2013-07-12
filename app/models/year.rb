class Year < ActiveRecord::Base
  attr_accessible :year, :semesters_attributes
  belongs_to :user
  has_many :semesters
  accepts_nested_attributes_for :semesters, :allow_destroy => true
end
