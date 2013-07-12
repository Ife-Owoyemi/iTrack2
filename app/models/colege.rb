class Colege < ActiveRecord::Base
  belongs_to :catalog	
  attr_accessible :catalog_id, :colegename, :departments_attributes
  has_many :departments
  accepts_nested_attributes_for :departments, :allow_destroy => true



end