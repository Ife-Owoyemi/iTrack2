class Catalog < ActiveRecord::Base
  belongs_to :institution
  attr_accessible :institution_id, :coleges_attributes
  has_many :coleges
  accepts_nested_attributes_for :coleges, :allow_destroy => true

  def self.distributionbuilder(model)
  	i = 0 
	@ucatalog = Hash.new
	@ucatalog["di"] = Hash.new
	@ucatalog["dii"] = Hash.new
	@ucatalog["diii"] = Hash.new
	model.each do |catalog|
		@colleges = catalog.coleges.all
		@colleges.each do |college| 
			college.colegename
			@departments = college.departments.all 
			@departments.each do |department|
				@nums = department.nums.all
				@nums.each do |num|
					if num.number != nil 
						if num.di 
							@ucatalog["di"][department.departmentabbr + " " + num.number.to_s] = num.credit
						end
						if num.dii
							@ucatalog["dii"][department.departmentabbr + " " + num.number.to_s] = num.credit
						end
						if num.diii
							@ucatalog["diii"][department.departmentabbr + " " + num.number.to_s] = num.credit
						end
					end
				end
			end
			i += 1
		end
	end
	return @ucatalog
  end

end
