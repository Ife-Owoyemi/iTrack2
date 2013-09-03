class Corereq < ActiveRecord::Base
  attr_accessible :specialty_id, :corereqname, :cgoal, :hgoal, :ccourses_attributes
  belongs_to :specialty
  has_many :ccourses, dependent: :destroy
  accepts_nested_attributes_for :ccourses, :allow_destroy => true

	def self.coreclasschecker(targetcoursehash, classmodel, usedcoursearray, holder)
		if targetcoursehash.has_key?(classmodel.department)
			if targetcoursehash[classmodel.department].has_key?(classmodel.num.to_s)
				usedcoursearray << classmodel.department + " " + classmodel.num.to_s
				holder += 1
			end
		end
		return holder, usedcoursearray
	end
end
