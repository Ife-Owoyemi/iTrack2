class Conference < ActiveRecord::Base
  attr_accessible :conend, :conbegin, :conferencename, :contakeaway, :tipsforapp, :user_id
  belongs_to :user

  validates :conbegin, presence: true
  validates :conend, presence: true
  validates :conferencename, presence: true
  validates :contakeaway, presence: true

end
