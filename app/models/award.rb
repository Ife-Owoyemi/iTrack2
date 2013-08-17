class Award < ActiveRecord::Base
  attr_accessible :awardperks, :awardprereqs, :awardtitle, :providername, :tipsforapp, :year
end
