class Specialty < ActiveRecord::Base
  attr_accessible :achievementname_id, :specialty, :corereqs_attributes, :opreqs_attributes
  belongs_to :achievementname
  has_many :corereqs, dependent: :destroy
  has_many :opreqs, dependent: :destroy
  accepts_nested_attributes_for :corereqs, :allow_destroy => true
  accepts_nested_attributes_for :opreqs, :allow_destroy => true


  
end
