class Ccourse < ActiveRecord::Base
  belongs_to :corereq	
  attr_accessible :corereq_id, :department, :num

end
