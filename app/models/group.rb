class Group < ActiveRecord::Base
  attr_accessible :cgoal, :groupname, :groupopreq_id, :options_attributes
  belongs_to :groupopreq
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, :allow_destroy => true
end
