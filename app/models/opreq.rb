class Opreq < ActiveRecord::Base
  belongs_to :specialty	
  attr_accessible :specialty_id, :opreqname, :options_attributes
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, :allow_destroy => true
	def self.optionclasschecker(targetcoursehash, classmodel, usedcoursearray, optioncount, targetcoursecount)
		if targetcoursehash != nil
			if targetcoursehash.has_key?(classmodel.department)
				if targetcoursehash[classmodel.department].has_key?(classmodel.num.to_s)
					usedcoursearray << classmodel.department + " " + classmodel.num.to_s
					optioncount += 1
					targetcoursecount += 1
				end
			end
		end
		return [usedcoursearray, optioncount, targetcoursecount]
	end
	def self.optiondataevaluator(optionmodel, mostcompleteoptiongoalholder, mostcompleteoptioncourseinputsum, largestpercentoptioncompletion, optioncount, input1, input2, input3, output1, output2, output3)
		if optionmodel.cgoal.to_i != 0
			if (optioncount * 100) / optionmodel.cgoal.to_i >= largestpercentoptioncompletion
				if optionmodel.cgoal.to_i < optioncount
					mostcompleteoptioncourseinputsum = optionmodel.cgoal.to_i
					if optionmodel.cgoal.to_i < input1
						output1 = optionmodel.cgoal.to_i
						output2 = 0
						output3 = 0
					elsif optionmodel.cgoal.to_i < input1 + input2
						output1 = input1
						output2 = optionmodel.cgoal.to_i - input1
						output3 = 0
					else
						output1 = input1 
						output2 = input2
						output3 = optionmodel.cgoal.to_i - input1 - input2
					end
				else
					mostcompleteoptioncourseinputsum = optioncount
					output1 = input1 
					output2 = input2
					output3 = input3
				end
				mostcompleteoptiongoalholder = optionmodel.cgoal.to_i
				largestpercentoptioncompletion = (optioncount * 100)/ optionmodel.cgoal.to_i
			end
		end
		return [mostcompleteoptiongoalholder, largestpercentoptioncompletion, mostcompleteoptioncourseinputsum, output1, output2, output3]
	end
end
