class Course < ActiveRecord::Base
  attr_accessible :content, :user_id
  validates :content, :length => { :maximum => 7 }
end
