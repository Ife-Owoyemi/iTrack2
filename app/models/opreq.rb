class Opreq < ActiveRecord::Base
  belongs_to :specialty	
  attr_accessible :specialty_id, :opreqname, :options_attributes
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, :allow_destroy => true

end
