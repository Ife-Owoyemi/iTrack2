class Ap < ActiveRecord::Base
  attr_accessible :user_id, :usercourses_attributes
  belongs_to :user
  has_many :usercourses  
  accepts_nested_attributes_for :usercourses, :allow_destroy => true

  def self.userApExists?(user_id)
  	bol = Ap.exists?(:user_id => user_id)
  	return bol
  end

  def self.findAp(user_id)
  	ap = Ap.find(:first, :conditions => ["user_id=?",user_id])
  	return ap
  end



end
