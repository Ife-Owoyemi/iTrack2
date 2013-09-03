class Semester < ActiveRecord::Base
  attr_accessible :semester, :usercourses_attributes, :year_id
  belongs_to :year
  has_many :usercourses
  accepts_nested_attributes_for :usercourses, :allow_destroy => true


  def self.userSemesterExists?(year_id,semester)
  	bol = Semester.exists?(:year_id => year_id, :semester => semester)
  	return bol
  end

  def self.findSemester(year_id,semester)
  	semester = Semester.find(:first, :conditions => ["year_id=? and semester=?",year_id,semester])
  	return semester
  end

end
