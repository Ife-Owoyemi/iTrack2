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
  attr_accessible :email, :name, :year, :status, :password, :password_confirmation, :college, :dreamJob, :years_attributes, :userachievementtypes_attributes, :notesToFresh, :notesToMym, :matricuYear, :postGradPlans, :hideemail, :hideprofile
  has_many :userachievementtypes
  has_many :years
  has_many :internships
  has_many :awards
  has_many :conferences
  accepts_nested_attributes_for :userachievementtypes, :allow_destroy => true
  accepts_nested_attributes_for :years, :allow_destroy => true
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  has_many :courses

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
  					uniqueness: { case_sensitive: false }
  #validates :password, presence: true, length: { minimum: 6 }
  #validates :password_confirmation, presence: true
  after_validation {self.errors.messages.delete(:password_digest) }

=begin  
  # Solr search setup
  searchable do 
    text :name, :email, :college, :dreamJob, :status
  end

 # bundle exec rake sunspot:solr:start or bundle exec rake sunspot:solr:run to start in foreground

# reIndex Solr important when pushing up to Heroku for old users that 
# were not indexed or for new attributes
  def self.reIndexSolr
    User.reindex
    Sunspot.commit
  end


# function gets a certain search and the search value and uses Solr to find 
# users with that match the given conditions
  def self.searchBy(q,search_type) 
 
    if (search_type == "Email")    
      User.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:email)
        end
      end  

    elsif (search_type == "College")    
      User.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:college)
        end
      end

    elsif (search_type == "Dream Job")    
      User.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:dreamJob)
        end
      end

    else    
      User.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:name)
        end
      end
    end
  end

=end

  require 'will_paginate/array' # need this line to use will_paginate with an array

# function gets a certain search and the search value and uses rails where and like methods instead of solr to find 
# users with that match the given conditions
  def self.railSearchBy(q,search_type) 
    if (search_type == "Email")    
      results = User.where(['email LIKE ?', "%#{q}%"])

    elsif (search_type == "College")    
      results = User.where(['college LIKE ?', "%#{q}%"])

    elsif (search_type == "Dream Job")    
      results = User.where(['dreamJob LIKE ?', "%#{q}%"])

    elsif (search_type == "Post Grad Plans")
      results = User.where(['postGradPlans Like ?', "%#{q}%"])

    else    
      results = User.where(['name LIKE ?', "%#{q}%"])

    end
    return results
  end




# return all current users names
  def self.allNames
    User.all.map(&:name)
  end

# return all current users' emails
  def self.allEmails
    User.all.map(&:email)
  end

# find all current users' dreamjobs
  def self.allDreamJobs
    dreamJobs = []
    User.all.each do |user|
      if (user.dreamJob != nil )
        dreamJobs << user.dreamJob
      else
        dreamJobs << "not set"
      end
    end
    return dreamJobs
  end

# find all current users' colleges
  def self.allColleges
    colleges = []
    User.all.each do |user|
      if (user.college != nil )
        colleges << user.college
      else
        colleges << "not set"
      end
    end
    return colleges
  end 

# Find User MArgin finds all the users that mtach a certain segment. Ex: all Undergrad
# It is to be used by more specific functions i.e. findUndergrads

  def self.findUserSegment(users,segment)
    user_ids = users.map(&:id)
    returnUsers = []
    potUsers = User.find(user_ids)
    potUsers.each do |pUser|
      if (pUser.status == segment)
        returnUsers << pUser
      end
    end
    return returnUsers.paginate(:page => 1, :per_page => 10)
  end   

  def self.findUndergrads(users)
    User.findUserSegment(users, "Undergrad")
  end   

  def self.findAlumi(users)
    User.findUserSegment(users, "Alumni")
  end   

  def self.findProspStu(users)
    User.findUserSegment(users, "Prospective Student")    
  end       

#  def self.searchByTrack(qTrack)

#  end


  def feed
    # this is preliminary. See "Following users" for the full implementation.
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

private
	def create_remember_token
		self.remember_token = SecureRandom.urlsafe_base64
	end
end
