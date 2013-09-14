class Usercourse < ActiveRecord::Base
  attr_accessible :credits, :department, :institution, :num, :status, :prof, :grade, :profquality, :hpweek, :follows, :nomidterms, :noessays, :nopprojects, :nogprojects, :nofinals, :suggest, :ap_id, :transfer_id, :semester_id
  belongs_to :semester
  belongs_to :ap
  belongs_to :transfer  

  # this function creates a course from the modal on the transcript page
  def self.createSemesterCourseFromTracks(semester,department,num,credits,grade)
  	course = semester.usercourses.create!(:department => department, :num => num, :credits => credits, :status => "Taken", :institution => "Rice", :grade => grade, :prof => 'Click to enter Professor', :profquality => 5, :hpweek => 5, :follows => '50/50', :nomidterms => 0, :noessays => 0, :nopprojects => 0, :nogprojects => 0, :suggest => 'Add tips, or location of useful outside resources to suceed in this class', :nofinals => 0)
  	return course
  end

  # this function creates a usercourse from the semester information found in a transcript file
  def self.createSemesterCourseWithTranscript(semester,department,num,numOfcredits,grade)
  	course = semester.usercourses.create!(:department => department, :num => num, :credits => numOfcredits, :status => "Taken", :institution => "Rice", :grade => grade, :prof => 'Click to enter Professor', :profquality => 5, :hpweek => 5, :follows => '50/50', :nomidterms => 0, :noessays => 0, :nopprojects => 0, :nogprojects => 0, :suggest => 'Add tips, or location of useful outside resources to suceed in this class', :nofinals => 0)
  	return course
  end

  def self.semesterCourseExists?(semester_id,department,num)
  	bol = Usercourse.exists?(:semester_id => semester_id,:department => department, :num => num)
 	return bol
  end

  def self.semesterCourseExistsByDepNum?(department,num)
    bol = Usercourse.exists?(:department => department, :num => num)
  return bol
  end  

  def self.findByNumAndDep(num,department)
    courses = Usercourse.find(:all, :conditions => ["num=? and department=?",num,department])
    return courses
  end


  def self.apExists?


  end

  def self.createApCourseWithTranscript(ap,department,num,numOfcredits)
    course = ap.usercourses.create!(:department => department, :num => num, :credits => numOfcredits, :status => "Taken", :institution => nil, :grade => "", :prof => 'Click to enter Professor', :profquality => 5, :hpweek => 5, :follows => '50/50', :nomidterms => 0, :noessays => 0, :nopprojects => 0, :nogprojects => 0, :suggest => 'Add tips, or location of useful outside resources to suceed in this class', :nofinals => 0)
    return course
  end

  def self.createTransferCourseWithTranscript(transfer,department,num,credits,grade)

  end  


end
