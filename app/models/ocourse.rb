class Ocourse < ActiveRecord::Base
  belongs_to :option
  attr_accessible :option_id, :department, :num

end
