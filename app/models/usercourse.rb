class Usercourse < ActiveRecord::Base
  attr_accessible :credits, :department, :institution, :num, :status, :prof, :grade, :profquality, :hpweek, :follows, :nomidterms, :noessays, :nopprojects, :nogprojects, :nofinals, :suggest, :ap_id, :transfer_id, :semester_id
  belongs_to :semester
  belongs_to :ap
  belongs_to :transfer  

  def self.createSemesterCourseWithTranscript(semester,department,num,credits,grade)
  	semester.Usercourses.create!(:department => department, :num => num, :credits => credits, :status => "Taken", :institution => "Rice", :grade => grade, :prof => 'Click to enter Professor', :profquality => 5, :hpweek => 5, :follows => '50/50', :nomidterms => 0, :noessays => 0, :nopprojects => 0, :nogprojects => 0, :suggest => 'Add tips, or location of useful outside resources to suceed in this class', :nofinals => 0)
  end

  def self.semesterCourseExists?(semester_id,department,num)
  	bol = Usercourses.exists(:semester_id => semester_id,:department => department, :num => num)
 	return bol
  end


  def self.apExists?


  end

  def self.createApCourseWithTranscript(ap,department,num,credits,grade)

  end

  def self.createTransferCourseWithTranscript(transfer,department,num,credits,grade)

  end  

  def createSemesterCourseFromTracks()

  end


end
