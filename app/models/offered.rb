class Offered < ActiveRecord::Base
  belongs_to :num	
  attr_accessible :professor, :semester, :year

end
