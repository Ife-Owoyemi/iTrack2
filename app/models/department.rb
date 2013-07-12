class Department < ActiveRecord::Base
  belongs_to :colege	
  attr_accessible :colege_id, :departmentabbr, :departmentname, :nums_attributes
  has_many :nums
  accepts_nested_attributes_for :nums, :allow_destroy => true


end