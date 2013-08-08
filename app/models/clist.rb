class Clist < ActiveRecord::Base
  attr_accessible :dep_id, :department, :num
  belongs_to :dep
end
