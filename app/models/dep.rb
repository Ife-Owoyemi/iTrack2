class Dep < ActiveRecord::Base
  attr_accessible :department, :depnumreq_id, :bounds_attributes, :cexceptions_attributes, :clists_attributes
  belongs_to :depnumreq
  has_many :bounds, dependent: :destroy
  has_many :cexceptions, dependent: :destroy
  has_many :clists, dependent: :destroy
  accepts_nested_attributes_for :clists, :allow_destroy => true
  accepts_nested_attributes_for :cexceptions, :allow_destroy => true
  accepts_nested_attributes_for :bounds, :allow_destroy => true
end
