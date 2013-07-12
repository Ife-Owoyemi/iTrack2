class Institution < ActiveRecord::Base
  attr_accessible :nickname, :name, :achievementtypes_attributes
  has_many :achievementtypes, dependent: :destroy

  accepts_nested_attributes_for :achievementtypes, :allow_destroy => true
end
