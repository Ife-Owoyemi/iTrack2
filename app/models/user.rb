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
  attr_accessible :email, :name, :year, :status, :password, :password_confirmation, :college, :dreamJob, :years_attributes, :userachievementtypes_attributes
  has_many :userachievementtypes
  has_many :years
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
  
  # Solr search setup
  searchable do 
    text :name, :email, :college, :dreamJob, :status
  end

 # bundle exec rake sunspot:solr:start or sunspot:solr:run to start in foreground

  def self.reIndexSolr
    User.reindex
    Sunspot.commit
  end

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

    else (search_type == "Name")    
      User.search do
        paginate :page => 1, :per_page => 10 
        fulltext q do
          fields(:name)
        end
      end
    end
  end

  def self.allNames
    User.all.map(&:name)
  end

  def self.allEmails
    User.all.map(&:email)
  end

  def self.allDreamJobs
    User.all.map(&:dreamJob)
  end

  def self.allColleges
    User.all.map(&:college)
  end    

  def self.findUndergrads(users)
    user_ids = users.map(&:id)
    User.find(user_ids, :conditions => ["status = ?", "Undergrad"])
  end   

  def self.findAlumi(users)
    user_ids = users.map(&:id)
    User.find(user_ids, :conditions => ["status = ?", "Alumni"])
  end   

  def self.findProspStu(users)
    user_ids = users.map(&:id)
    User.find(user_ids, :conditions => ["status = ?", "Prospective Student"])
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
