class Num < ActiveRecord::Base
  belongs_to :department  
  attr_accessible :department_id, :name, :brief, :credit, :di, :dii, :diii, :number, :offered_attributes
  has_many :offereds

  accepts_nested_attributes_for :offereds, :allow_destroy => true

end