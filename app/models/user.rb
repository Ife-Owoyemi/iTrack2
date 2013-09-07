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
  
  #attr_accessible :coursearray, :usercoursesHash, :takenHash, :takingHash, :wtakeHash    


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
  
  def self.courseHashArrayGenerator(model)
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

  def self.usercourses(user)
    cuser_courses = Array.new
    user.years.all.each do |year| 
      year.semesters.all.each do |semester| 
        semester.usercourses.all.each do |course| 
        cuser_courses << course.department + " " + course.num.to_s 
        end 
      end 
    end 
    return cuser_courses
  end


  def self.studentachievementhashgenerator(achievementmodelsarray, achievementhash, taken, taking, wtake)
    @studentachievementhash = Hash.new
    for achievementtype in achievementmodelsarray
      if !@studentachievementhash.has_key?(achievementtype.achievementtype)
          @studentachievementhash[achievementtype.achievementtype] = Hash.new
        end
      achievementhash[achievementtype.achievementtype].each_key do |collegek|
        if !@studentachievementhash[achievementtype.achievementtype].has_key?(collegek)
          @studentachievementhash[achievementtype.achievementtype][collegek] = Hash.new
        end
        collegem = achievementtype.colleges.where(:college => collegek )
        collegem.each do |college|
          collegehash = achievementhash[achievementtype.achievementtype][college.college]
          collegehash.each_key do |achievementnamek|
            if !@studentachievementhash[achievementtype.achievementtype][collegek].has_key?(achievementnamek)
              @studentachievementhash[achievementtype.achievementtype][collegek][achievementnamek] = Hash.new
            end
            achievementnamemarray = college.achievementnames.where(:achievementname => achievementnamek )
            achievementnamemarray.each do |achievementname|             
              
                collegehash[achievementnamek].each_key do |specialtyk|
                  specialtymarray = achievementname.specialties.where(:specialty => specialtyk)
                  specialtymarray.each do |specialty|
                    
                    @studentachievementhash[achievementtype.achievementtype][collegek][achievementnamek][specialtyk] = Specialty.calculate(specialty, taken, taking, wtake)
                    
                  end
                end
              
            end
          end
        end
      end
    end
    return @studentachievementhash
  end

  require "csv"
  #require 'iconv'


  def transcriptReader(transcriptFile)
    @transcript = Hash.new # => @user
    #delete all usercourses currently made up.
    @years = Array.new # => an array used to prevent multiple instances of the same year being made

    #file_string = transcriptFile.read.force_encoding("ISO-8859-1").encode!("utf-8", "utf-8", :invalid => :replace)
    
    #Begin running through all of the rows in the cell
    CSV.foreach(transcriptFile.path, col_sep: "$", encoding: "ISO8859-1") do |cell|
      # First I noticed that there was this string sequence of "Term:" before rice courses were listed.

          # debugging help -Ife
              #puts cell[0][0..6]
          # end debugging help

      if cell[0][0..4] == "Term:"
        @countcourse = false
        # so here we construct the year as a 4 digit number given they are listed as two digits on the transcript
        @year = cell[0][11..12].to_i + 2000

        # Now we take a sample of the letters following the segment "Term:"
        semesterpartial = cell[0][6..9]
        # Here is a loop that finds what semester is referenced
 
        #  Fall
        if semesterpartial == "Fall"
          @semester = "Fall"
          @year = cell[0][11..12].to_i + 2000
        # Summer
        elsif semesterpartial == "Summ"
          @semester = "Summer"
          @year = cell[0][13..14].to_i + 2000
        # Spring
        elsif semesterpartial == "Spri"
          @semester = "Spring"
          @year = cell[0][13..14].to_i + 2000
        end
 
        # Here we determine if the instance of the loop has been created
 
        # If it is not included
        if !@years.include?((@year).to_s)
          # Create a new year instance
          @transcript[@year.to_s] = Hash.new
          # We add it to the years that have been made
          @years << (@year).to_s
        end
 
        # Create a new semester instance within the current year
        @transcript[@year.to_s][@semester] = Hash.new
 
        # Here we define a variable that will allow courses after this to be made into instances
        @algkey = "Rice"

        # Before courses are listed in a transcript a title line is defined.
        # I used the existence of this line to define a variable that allows for following lines to fall into else and turn into created courses.  
      elsif cell[0][0..6] == "Subject"
        @countcourse = true
        # Defines the end of a series of courses  nil is the ap stop and Term  is the end of others
     
        # These were two key phrases that are found after course listings have ended and I used them to define the end of where lines are allowed to be created into courses
 
      elsif cell[0][0..4] == "Term " #or cell[1] == nil
        @countcourse = false
        # I found that AP Courses for my transcript were prefaced with "Fall" so I used it to define the begining of AP course listings
      elsif cell[0][0..3] == "Fall"
          @algkey = "AP"
          # Create an AP instance
          @transcript["AP"] = Hash.new
      else
        # Given @countcourse is true then lines that fall through this avenue are courses that are about to be created.

          # debugging help -Ife
            #for i in 0..1
            #  puts "Else Statement"
            #end
          # end debugging help


        if @countcourse
          # if they are ap they follow this route

          # debugging help -Ife
            #for i in 0..10
              #puts "Courseeeeeeeee" + cell[0][0..6]
            #end
          # end debugging help


          if @algkey == "AP"
            depabbr = cell[0]
            # Corrects for COMC num of TST
            if cell[1] == "TST"
              num = 000
            else
              num = cell[1]
            end
            credits = cell[8]
 
            @transcript["AP"][depabbr + " " + num.to_s] = Hash.new
            @transcript["AP"][depabbr + " " + num.to_s][:credits] = credits
            # Here is where transfers would fall but I dont know yet.
          elsif @algkey == "Transfer"
             
            # Here is where regular rice courses are defined
          elsif @algkey == "Rice"
            #depabbr = cell[0]
            depabbr = cell[0][0..3]
            if cell[1] == "TST"
              num = 100
            else
              #num = cell[1]
              num = cell[0][5..7]
            end

            allInfo = cell[0]
            organizedInfo = cell[0].split(",,,,,")
            usefulInfo = organizedInfo[1]
            usefulCourseInfo = usefulInfo.split(",")
            grade = usefulCourseInfo[0]
            credits = usefulCourseInfo[1]
            puts credits
            if @year == 2013 and @semester == "Fall"
              #i grade = cell[0][-7]
              #i credits = cell[0][-5]
              #grade = cell[9]
              #credits = cell[10]
            else
              #i grade = cell[0][-7]
              #i credits = cell[0][-5]              
              #grade = cell[9]
              #credits = cell[10]
            end

          # debugging help -Ife
            #for i in 0..10
              #puts depabbr
              #puts num
            #end
          # end debugging help

            @transcript[@year.to_s][@semester][depabbr + " " + num.to_s] = Hash.new
            @transcript[@year.to_s][@semester][depabbr + " " + num.to_s][:grade] = grade
            @transcript[@year.to_s][@semester][depabbr + " " + num.to_s][:credits] = credits.to_i
          end
        end
      end
      #algorithmkey
    end
    createCoursesFromTranscript(@transcript)
  end

  def createCoursesFromTranscript(transcriptHash)

    transcriptHash.each_key do |year|

      if year == "AP" # if the class is an AP course do the following
        transcriptHash["AP"].each_key do |course|
        
        end


      elsif year == "Transfer" # if the course is a Transfer course do the following 
        # transfer code here

    
      else # if the course if a course from the university do the following
        yearInteger = year.to_i
        user_id = self.id
        if ( Year.userYearExists?(user_id, yearInteger) == true) # check if the year already exist for this user
          courseYear = Year.findYear(user_id,yearInteger) # if year set the course to the year
        else # if year does not exist set courseYear to a new year
          courseYear = self.years.create!(:year => yearInteger) 
        end

        transcriptHash[year].each_key do |semester| # go through each semester for this year
        
          if (Semester.userSemesterExists?(courseYear.id,semester)) # if the semester for the year exists set the semester to that semester  
            courseSemester = Semester.findSemester(courseYear.id,semester)
          else
            courseSemester = courseYear.semesters.create!(:semester => semester)# will also need to create the appropriate semesters for this year
          end

          # debugging help
          if (transcriptHash[year][semester].empty?)
            for i in 0..10
              puts "EMPTY!!!!!!"
            end
          end

          # this sections looks through the semester's course to create the usercourses
          transcriptHash[year][semester].each_key do |courseInfo|
            courseInfoArray = courseInfo.split(' ') 
            dep = courseInfoArray[0]
            num = courseInfoArray[1].to_i
            credits = transcriptHash[year][semester][courseInfo][:credits]
            grade = transcriptHash[year][semester][courseInfo][:grade]
            # create the course if it doesn't already exist
            if ( Usercourse.semesterCourseExists?(courseSemester.id,dep,num) == false )
              puts credits
              Usercourse.createSemesterCourseWithTranscript(courseSemester,dep,num,credits,grade) # create usercourse with info from hash for the hash
            end

          end
        end
      end
    end

  end # end of this method



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
    
    #self.coursearray = Array.new
    #self.usercoursesHash = Hash.new   
    #self.takenHash = Hash.new 
    #self.takingHash = Hash.new 
    #self.wtakeHash = Hash.new  

    aps = self.aps.all
    transfers = self.transfers.all
    years = self.years.all

    aps.each do |ap|
      courses = ap.usercourse.all
      courses.each do |c|
        self.coursearray << c.department + " " + c.num.to_s
        if !self.usercoursesHash.has_key?(c.department)
          self.usercoursesHash[c.department] = Hash.new
          self.usercoursesHash[c.department][c.num] = Hash.new
          self.usercoursesHash[c.department][c.num] = c.credits
        else
          self.usercoursesHash[c.department][c.num] = Hash.new
          self.usercoursesHash[c.department][c.num] = c.credits
        end
        if !self.takenHash.has_key?(c.department)
          self.takenHash[c.department] = Hash.new 
          self.takenHash[c.department][c.num] = Hash.new
          self.takenHash[c.department][c.num] = c.credits
        else
          self.takenHash[c.department][c.num] = Hash.new
          self.takenHash[c.department][c.num] = c.credits
        end
      end
    end

    transfers.each do |transfer|
      courses = transfer.usercourses.all
      courses.each do |c|
        self.coursearray << c.department + " " + c.num.to_s
        if !self.usercoursesHash.has_key?(c.department)
          self.usercoursesHash[c.department] = Hash.new
          self.usercoursesHash[c.department][c.num] = Hash.new
          self.usercoursesHash[c.department][c.num] = c.credits
        else
          self.usercoursesHash[c.department][c.num] = Hash.new
          self.usercoursesHash[c.department][c.num] = c.credits
        end
        if !self.takenHash.has_key?(c.department)
          self.takenHash[c.department] = Hash.new
          self.takenHash[c.department][c.num] = Hash.new
          self.takenHash[c.department][c.num] = c.credits
        else
          self.takenHash[c.department][c.num] = Hash.new
          self.takenHash[c.department][c.num] = c.credits
        end  
      end
    end  

    years.each do |year|
      semesters = year.semesters.all
      semesters.each do |semester|
        courses = semester.usercourses.all
        courses.each do |c|
          self.coursearray << c.department + " " + c.num.to_s
          if !self.usercoursesHash.has_key?(c.department)
            self.usercoursesHash[c.department] = Hash.new
            self.usercoursesHash[c.department][c.num] = Hash.new
            self.usercoursesHash[c.department][c.num] = c.credits
          else  
            self.usercoursesHash[c.department][c.num] = Hash.new
            self.usercoursesHash[c.department][c.num] = c.credits
          end  
          if c.status == "Taken"
            if !self.takenHash.has_key?(c.department)
              self.takenHash[c.department] = Hash.new
              self.takenHash[c.department][c.num] = Hash.new
              self.takenHash[c.department][c.num] = c.credits
            else  
              self.takenHash[c.department][c.num] = Hash.new
              self.takenHash[c.department][c.num] = c.credits
            end  
          elsif c.status == "Taking"
            if !self.takingHash.has_key?(c.department)
              self.takingHash[c.department] = Hash.new
              self.takingHash[c.department][c.num] = Hash.new
              self.takingHash[c.department][c.num] = c.credits
            else  
              self.takingHash[c.department][c.num] = Hash.new
              self.takingHash[c.department][c.num] = c.credits
            end
          elsif c.status == "Will Take"
            if !self.wtakeHash.has_key?(c.department)
              self.wtakeHash[c.department] = Hash.new
              self.wtakeHash[c.department][c.num] = Hash.new
              self.wtakeHash[c.department][c.num] = c.credits
            else
              self.wtakeHash[c.department][c.num] = Hash.new
              self.wtakeHash[c.department][c.num] = c.credits
            end
          end
        end
      end
    end    

    self.save      

  end

  # call after user adds new ap course
  def apCourseHashAdd(usercourse)
    c = usercourse
    self.coursearray << c.department + " " + c.num.to_s
    if !self.usercoursesHash.has_key?(c.department)
      self.usercoursesHash[c.department] = Hash.new
      self.usercoursesHash[c.department][c.num] = Hash.new
      self.usercoursesHash[c.department][c.num] = c.credits
    else
      self.usercoursesHash[c.department][c.num] = Hash.new
      self.usercoursesHash[c.department][c.num] = c.credits
    end
    if !self.takenHash.has_key?(c.department)
      self.takenHash[c.department] = Hash.new 
      self.takenHash[c.department][c.num] = Hash.new
      self.takenHash[c.department][c.num] = c.credits
    else
      self.takenHash[c.department][c.num] = Hash.new
      self.takenHash[c.department][c.num] = c.credits
    end    
  end

  # call after user adds new transfer course
  def transferCourseHashAdd(usercourse)

    c = usercourse
    self.coursearray << c.department + " " + c.num.to_s
    if !self.usercoursesHash.has_key?(c.department)
      self.usercoursesHash[c.department] = Hash.new
      self.usercoursesHash[c.department][c.num] = Hash.new
      self.usercoursesHash[c.department][c.num] = c.credits
    else
      self.usercoursesHash[c.department][c.num] = Hash.new
      self.usercoursesHash[c.department][c.num] = c.credits
    end
    if !self.takenHash.has_key?(c.department)
      self.takenHash[c.department] = Hash.new
      self.takenHash[c.department][c.num] = Hash.new
      self.takenHash[c.department][c.num] = c.credits
    else
      self.takenHash[c.department][c.num] = Hash.new
      self.takenHash[c.department][c.num] = c.credits
    end  

  end

  # call after user adds new semester course
  def semesterCourseHashAdd(usercourse)

    c = usercourse
    self.coursearray << c.department + " " + c.num.to_s
    if !self.usercoursesHash.has_key?(c.department)
      self.usercoursesHash[c.department] = Hash.new
      self.usercoursesHash[c.department][c.num] = Hash.new
      self.usercoursesHash[c.department][c.num] = c.credits
    else  
      self.usercoursesHash[c.department][c.num] = Hash.new
      self.usercoursesHash[c.department][c.num] = c.credits
    end  
    if c.status == "Taken"
      if !self.takenHash.has_key?(c.department)
        self.takenHash[c.department] = Hash.new
        self.takenHash[c.department][c.num] = Hash.new
        self.takenHash[c.department][c.num] = c.credits
      else  
        self.takenHash[c.department][c.num] = Hash.new
        self.takenHash[c.department][c.num] = c.credits
      end  
    elsif c.status == "Taking"
      if !self.takingHash.has_key?(c.department)
        self.takingHash[c.department] = Hash.new
        self.takingHash[c.department][c.num] = Hash.new
        self.takingHash[c.department][c.num] = c.credits
      else  
        self.takingHash[c.department][c.num] = Hash.new
        self.takingHash[c.department][c.num] = c.credits
      end
    elsif c.status == "Will Take"
      if !self.wtakeHash.has_key?(c.department)
        self.wtakeHash[c.department] = Hash.new
        self.wtakeHash[c.department][c.num] = Hash.new
        self.wtakeHash[c.department][c.num] = c.credits
      else
        self.wtakeHash[c.department][c.num] = Hash.new
        self.wtakeHash[c.department][c.num] = c.credits
      end
    end   

  end  

  # initiate the serilized Hash for certain users (array of users)
  def self.initSerialHashesForUsers(users)
    users.each do |user|
      user.serializedCourseDataInit
    end
  end

  # initiate the serilized Hash for a certain user 
  def self.initSerialHashForUser(user)
    user.serializedCourseDataInit
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
