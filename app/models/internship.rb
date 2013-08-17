class Internship < ActiveRecord::Base
  attr_accessible :internbegin, :internend, :internprereqs, :providername, :source, :stutitle, :tipsforapp
  belongs_to :user

  validates :internbegin, presence: true
  validates :internend, presence: true
  validates :internprereqs, presence: true
  validates :providername, presence: true
  validates :source, presence: true 
  validates :stutitle, presence: true


end
