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
  attr_accessible :email, :name, :year, :status, :password, :password_confirmation, :college, :dreamJob, :years_attributes, :aps_attributes, :transfers_attributes, :userachievementtypes_attributes, :notesToFresh, :notesToMym, :matricuYear, :postGradPlans, :hideemail, :hideprofile
  
  # serialize arrays and hash attributes used when loading 
  serialize :coursearray, Array
  serialize :usercoursesHash, Hash  
  serialize :takenHash, Hash
  serialize :takingHash, Hash
  serialize :wtakeHash, Hash

  has_many :userachievementtypes
  has_many :years
  has_many :internships
  has_many :awards
  has_many :conferences
  has_many :aps
  has_many :transfers
  accepts_nested_attributes_for :userachievementtypes, :allow_destroy => true
  accepts_nested_attributes_for :years, :allow_destroy => true
  accepts_nested_attributes_for :aps, :allow_destroy => true
  accepts_nested_attributes_for :transfers, :allow_destroy => true
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
  
  def self.sampleFunction1(model)
    taken = Hash.new
    taking = Hash.new
    wtake = Hash.new
    coursearray = Array.new
    user_courses = Hash.new
    aps = model.aps.all
    aps.each do |ap|
      courses = ap.usercourses.all
      courses.each do |c|
        coursearray << c.department + " " + c.num.to_s
        if !user_courses.has_key?(c.department)
          user_courses[c.department] = Hash.new
          user_courses[c.department][c.num] = Hash.new
          user_courses[c.department][c.num] = c.credits
        else
          user_courses[c.department][c.num] = Hash.new
          user_courses[c.department][c.num] = c.credits
        end 
        if !taken.has_key?(c.department)
          taken[c.department] = Hash.new 
          taken[c.department][c.num] = Hash.new 
          taken[c.department][c.num] = c.credits 
        else
          taken[c.department][c.num] = Hash.new 
          taken[c.department][c.num] = c.credits
        end 
      end 
    end 
    transfers = model.transfers.all
    transfers.each do |transfer|
      courses = transfer.usercourses.all
      courses.each do |c|
        coursearray << c.department + " " + c.num.to_s
        if !user_courses.has_key?(c.department)
          user_courses[c.department] = Hash.new
          user_courses[c.department][c.num] = Hash.new
          user_courses[c.department][c.num] = c.credits
        else
          user_courses[c.department][c.num] = Hash.new
          user_courses[c.department][c.num] = c.credits
        end 
        if !taken.has_key?(c.department)
          taken[c.department] = Hash.new
          taken[c.department][c.num] = Hash.new
          taken[c.department][c.num] = c.credits
        else
          taken[c.department][c.num] = Hash.new
          taken[c.department][c.num] = c.credits 
        end 
      end
    end
    years = model.years.all
    years.each do |year|
      @semesters = year.semesters.all
      @semesters.each do |semester|
        @courses = semester.usercourses.all
        @courses.each do |c|
          coursearray << c.department + " " + c.num.to_s
          if !user_courses.has_key?(c.department)
            user_courses[c.department] = Hash.new
            user_courses[c.department][c.num] = Hash.new
            user_courses[c.department][c.num] = c.credits
          else 
            user_courses[c.department][c.num] = Hash.new 
            user_courses[c.department][c.num] = c.credits
          end 
          if c.status == "Taken"
            if !taken.has_key?(c.department)
              taken[c.department] = Hash.new 
              taken[c.department][c.num] = Hash.new
              taken[c.department][c.num] = c.credits
            else
              taken[c.department][c.num] = Hash.new
              taken[c.department][c.num] = c.credits
            end
          elsif c.status == "Taking"
            if !taking.has_key?(c.department)
              taking[c.department] = Hash.new
              taking[c.department][c.num] = Hash.new
              taking[c.department][c.num] = c.credits
            else
              taking[c.department][c.num] = Hash.new
              taking[c.department][c.num] = c.credits
            end
          elsif c.status == "Will Take"
            if !wtake.has_key?(c.department)
              wtake[c.department] = Hash.new
              wtake[c.department][c.num] = Hash.new
              wtake[c.department][c.num] = c.credits
            else
              wtake[c.department][c.num] = Hash.new
              wtake[c.department][c.num] = c.credits
            end
          end
        end
      end
    end
    return taken, taking, wtake, user_courses, coursearray
  end

  def self.usercourses(model)
    cuser_courses = Array.new
    model.years.all.each do |year| 
      year.semesters.all.each do |semester| 
        semester.usercourses.all.each do |course| 
        cuser_courses << course.department + " " + course.num.to_s 
        end 
      end 
    end 
    return cuser_courses
  end


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


# code that works with the new user_course_hash attributes
  def serializedCourseDataInit
    aps = self.aps.all
    transfers = self.transfers.all
    years = self.years.all

    aps.each do |ap|
      courses = ap.usercourse.all
      courses.each do |c|
        :coursearray << c.department + " " + c.num.to_s
        if !:usercoursesHash.has_key?(c.department)
          :usercoursesHash[c.department] = Hash.new
          :usercoursesHash[c.department][c.num] = Hash.new
          :usercoursesHash[c.department][c.num] = c.credits
        else
          :usercoursesHash[c.department][c.num] = Hash.new
          :usercoursesHash[c.department][c.num] = c.credits
        end
        if !:takenHash.has_key?(c.department)
          :takenHash[c.department] = Hash.new 
          :takenHash[c.department][c.num] = Hash.new
          :takenHash[c.department][c.num] = c.credits
        else
          :takenHash[c.department][c.num] = Hash.new
          :takenHash[c.department][c.num] = c.credits
        end
      end
    end

    transfers.each do |transfer|
      courses = transfer.usercourses.all
      courses.each do |c|
        :coursearray << c.department + " " + c.num.to_s
        if !:usercoursesHash.has_key?(c.department)
          :usercoursesHash[c.department] = Hash.new
          :usercoursesHash[c.department][c.num] = Hash.new
          :usercoursesHash[c.department][c.num] = c.credits
        else
          :usercoursesHash[c.department][c.num] = Hash.new
          :usercoursesHash[c.department][c.num] = c.credits
        end
        if !:takenHash.has_key?(c.department)
          :takenHash[c.department] = Hash.new
          :takenHash[c.department][c.num] = Hash.new
          :takenHash[c.department][c.num] = c.credits
        else
          :takenHash[c.department][c.num] = Hash.new
          :takenHash[c.department][c.num] = c.credits
        end  
      end
    end  

    years.each do |year|
      semesters = year.semesters.all
      semesters.each do |semester|
        courses = semester.usercourses.all
        courses.each do |c|
          :coursearray << c.department + " " + c.num.to_s
          if !:usercoursesHash.has_key?(c.department)
            :usercoursesHash[c.department] = Hash.new
            :usercoursesHash[c.department][c.num] = Hash.new
            :usercoursesHash[c.department][c.num] = c.credits
          else  
            :usercoursesHash[c.department][c.num] = Hash.new
            :usercoursesHash[c.department][c.num] = c.credits
          end  
          if c.status == "Taken"
            if !:takenHash.has_key?(c.department)
              :takenHash[c.department] = Hash.new
              :takenHash[c.department][c.num] = Hash.new
              :takenHash[c.department][c.num] = c.credits
            else  
              :takenHash[c.department][c.num] = Hash.new
              :takenHash[c.department][c.num] = c.credits
            end  
          elsif c.status == "Taking"
            if !:takingHash.has_key?(c.department)
              :takingHash[c.department] = Hash.new
              :takingHash[c.department][c.num] = Hash.new
              :takingHash[c.department][c.num] = c.credits
            else  
              :takingHash[c.department][c.num] = Hash.new
              :takingHash[c.department][c.num] = c.credits
            end
          elsif c.status == "Will Take"
            if !:wtakeHash.has_key?(c.department)
              :wtakeHash[c.department] = Hash.new
              :wtakeHash[c.department][c.num] = Hash.new
              :wtakeHash[c.department][c.num] = c.credits
            else
              :wtakeHash[c.department][c.num] = Hash.new
              :wtakeHash[c.department][c.num] = c.credits
            end
          end
        end
      end
    end    

    self.save      

  end

  def transferUserCoursesHash
    transfers = self.transfers.all
    courses = ap.usercourse.all
  end

  def semesterUserCoursesHash
    aps = self.aps.all
    courses = ap.usercourse.all
  end  

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
