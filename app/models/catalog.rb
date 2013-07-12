class Catalog < ActiveRecord::Base
  belongs_to :institution
  attr_accessible :institution_id, :coleges_attributes
  has_many :coleges
  accepts_nested_attributes_for :coleges, :allow_destroy => true



end
