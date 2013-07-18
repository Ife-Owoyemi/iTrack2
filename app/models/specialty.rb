class Specialty < ActiveRecord::Base
  attr_accessible :achievementname_id, :specialty, :corereqs_attributes, :opreqs_attributes, :groupopreqs_attributes, :depnumreqs_attributes, :notes, :advisor, :linkhome
  belongs_to :achievementname
  has_many :corereqs, dependent: :destroy
  has_many :opreqs, dependent: :destroy
  has_many :groupopreqs, dependent: :destroy
  has_many :depnumreqs, dependent: :destroy
  accepts_nested_attributes_for :corereqs, :allow_destroy => true
  accepts_nested_attributes_for :opreqs, :allow_destroy => true
  accepts_nested_attributes_for :groupopreqs, :allow_destroy => true
  accepts_nested_attributes_for :depnumreqs, :allow_destroy => true
  
end
