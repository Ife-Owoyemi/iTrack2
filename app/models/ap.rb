class Ap < ActiveRecord::Base
  attr_accessible :user_id
  belongs_to :user
  has_many :usercourses  
end
