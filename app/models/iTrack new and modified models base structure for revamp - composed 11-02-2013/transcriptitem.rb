class Transcriptitem < ActiveRecord::Base

  #Ife :I imagine transcriptitem as an experience and therefore more flexiblly (it can include credits, grade, proffesor name, etc.) but the actual course model it belongs to stays the same for that year  
  attr_accessible :credits, :status, :prof, :grade, :profquality, :hpweek, :follows, :nomidterms, :noessays, :nopprojects, :nogprojects, :nofinals, :suggest
  belongs_to :course
  belongs_to :user


end