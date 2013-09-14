class Depnumreq < ActiveRecord::Base
  attr_accessible :cgoal, :depnumreqname, :hgoal, :doublecount, :specialty_id, :deps_attributes
  belongs_to :specialty
  has_many :deps, dependent: :destroy
  accepts_nested_attributes_for :deps, :allow_destroy => true
  	def self.hourcounternodoublecount(targetcoursehash, countedcourse, numarray, holder, departmentmodel, notcountedcourseexceptionarray,
countedcourseexceptionarray, usedcoursearray )
		if targetcoursehash != nil
			if targetcoursehash.has_key?(departmentmodel.department)
				for num in numarray
					targetcoursehash[departmentmodel.department].each_key do |number|
						if !notcountedcourseexceptionarray.include?(departmentmodel.department + number)
							if (number.to_i >= num.min and number.to_i <= num.max) or !countedcourseexceptionarray.include?(departmentmodel.department + number.to_s)
								if !usedcoursearray.include?(departmentmodel.department + " " + number.to_s)
									countedcourse << departmentmodel.department + " " + number
									holder += targetcoursehash[departmentmodel.department][number]
								end
							end
						end
					end
				end
			end
		end
		return holder, countedcourse
	end
	def self.coursecounternodoublecount(targetcoursehash, countedcourse, numarray, holder, departmentmodel, notcountedcourseexceptionarray,
	countedcourseexceptionarray, usedcoursearray )
		if targetcoursehash != nil
			if targetcoursehash.has_key?(departmentmodel.department)
				for num in numarray
					targetcoursehash[departmentmodel.department].each_key do |number|
						if !notcountedcourseexceptionarray.include?(departmentmodel.department + number)
							if (number.to_i >= num.min and number.to_i <= num.max) or !countedcourseexceptionarray.include?(departmentmodel.department + number.to_s)
								if !usedcoursearray.include?(departmentmodel.department + " " + number.to_s)
								countedcourse << departmentmodel.department + " " + number
								holder += 1
								end
							end
						end
					end
				end
			end
		end
		return holder, countedcourse
	end

	def self.hourcounteryesdoublecount(targetcoursehash, countedcourse, numarray, holder, departmentmodel, notcountedcourseexceptionarray,
	countedcourseexceptionarray)
		if targetcoursehash != nil
			if targetcoursehash.has_key?(departmentmodel.department)
				for num in numarray
					targetcoursehash[departmentmodel.department].each_key do |number|
						if !notcountedcourseexceptionarray.include?(departmentmodel.department + number)
							if (number.to_i >= num.min and number.to_i <= num.max) or !countedcourseexceptionarray.include?(departmentmodel.department + number.to_s)
							holder += targetcoursehash[departmentmodel.department][number]
							countedcourse << departmentmodel.department + " " + number
							end
						end
					end
				end
			end
		end
		return holder, countedcourse
	end

	def self.coursecounteryesdoublecount(targetcoursehash,countedcourse, numarray, holder, departmentmodel, notcountedcourseexceptionarray,
	countedcourseexceptionarray)
		if targetcoursehash != nil
			if targetcoursehash.has_key?(departmentmodel.department)
				for num in numarray
					targetcoursehash[departmentmodel.department].each_key do |number|
						if !notcountedcourseexceptionarray.include?(departmentmodel.department + number)
							if (number.to_i >= num.min and number.to_i <= num.max) or !countedcourseexceptionarray.include?(departmentmodel.department + number.to_s)
							holder += 1
							countedcourse << departmentmodel.department + " " + number
							end
						end
					end
				end
			end
		end
		return holder, countedcourse
	end
	def self.correcting3partofwhole(input1, input2, input3, limit)
		inputsum = input1 + input2 + input3
		if limit < inputsum
			if limit < input1
				output1 = limit
				output2 = 0
				output3 = 0
			elsif limit < input1 + input2
				output1 = input1
				output2 = limit - input1
				output3 = 0
			else
				output1 = input1
				output2 = input2
				output3 = limit - input1 - input2
			end
		else
			output1 = input1
			output2 = input2
			output3 = input3
		end
		return output1, output2, output3
	end
end
