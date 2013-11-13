# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base

  attr_accessible :institution_id, :email, :name, :year, :status, :password, :password_confirmation, :college, :dreamJob, :userachievementtypes_attributes, :notesToFresh, :notesToMym, :matricuYear, :postGradPlans, :hideemail, :hideprofile
  belongs_to :institution

  has_many :transcriptitems
  has_many :internships
  has_many :awards
  has_many :conferences

  has_many :courses, through: :transcriptitems
 
end