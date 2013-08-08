class Bound < ActiveRecord::Base
  attr_accessible :dep_id, :max, :min
  belongs_to :dep
end
