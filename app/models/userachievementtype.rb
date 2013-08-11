class Userachievementtype < ActiveRecord::Base
  attr_accessible :achievementname, :achievementtype, :college, :specialty
  belongs_to :user

  searchable do
  	text :achievementname, :achievementtype, :college, :specialty
  end

  #def self.




end
