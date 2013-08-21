class Usercourse < ActiveRecord::Base
  attr_accessible :credits, :department, :institution, :num, :status, :prof, :grade, :profquality, :hpweek, :follows, :nomidterms, :noessays, :nopprojects, :nogprojects, :nofinals, :suggest, :ap_id, :transfer_id, :semester_id
  belongs_to :semester
  belongs_to :ap
  belongs_to :transfer  
end
