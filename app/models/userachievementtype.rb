class Userachievementtype < ActiveRecord::Base
  attr_accessible :achievementname, :achievementtype, :college, :specialty
  belongs_to :user
end
