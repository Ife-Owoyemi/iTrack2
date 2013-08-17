class Award < ActiveRecord::Base
  attr_accessible :awardperks, :awardprereqs, :awardtitle, :providername, :tipsforapp, :year
  belongs_to :user

  validates :awardperks, presence: true
  validates :awardprereqs, presence: true
  validates :awardtitle, presence: true
  validates :providername, presence: true
  validates :year, presence: true 

end
