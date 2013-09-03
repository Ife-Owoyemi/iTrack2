class Year < ActiveRecord::Base
  attr_accessible :year, :semesters_attributes, :user_id
  belongs_to :user
  has_many :semesters
  accepts_nested_attributes_for :semesters, :allow_destroy => true

  def self.userYearExists?(user_id,year)
  	bol = Year.exists?(:user_id => user_id, :year => year)
  	return bol
  end

  def self.findYear(user_id,year)
  	year = Year.find(:first, :conditions => ["user_id=? and year=?",user_id,year])
  	return year
  end

end
