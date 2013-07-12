class Usercourse < ActiveRecord::Base
  attr_accessible :credits, :department, :institution, :num, :status, :prof, :grade, :profquality, :hpweek, :follows, :nomidterms, :noessays, :nopprojects, :nogprojects, :nofinals, :suggest
  belongs_to :semester
  
end
