class Institution < ActiveRecord::Base
  attr_accessible :nickname, :name, :achievementtypes_attributes
  has_many :achievementtypes, dependent: :destroy

  accepts_nested_attributes_for :achievementtypes, :allow_destroy => true
  def self.achievementmodelfetcher(model, achievementhash)
  	achievement = Array.new
  	model.each do |type|
      a = type.achievementtypes.all
      a.each do |t|
        if achievementhash.has_key?(t.achievementtype) 
          achievement << t
        end
      end
    end
    return achievement
  end
end
