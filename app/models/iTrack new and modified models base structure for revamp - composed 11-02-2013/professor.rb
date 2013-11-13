class Professor < ActiveRecord::Base

	attr_accessible :name, :average_rating, :email, :office_location
	has_many :courses

end