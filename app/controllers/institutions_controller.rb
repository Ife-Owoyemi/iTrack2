class InstitutionsController < ApplicationController
	def index
		@institution = Institution.all
	end

	def new
		@institution = Institution.new
		achievementtype = @institution.achievementtypes.build
		college = achievementtype.colleges.build
		achievementname = college.achievementnames.build
		specialty = achievementname.specialties.build
		corereq = specialty.corereqs.build
		corereq.ccourses.build
		opreq = specialty.opreqs.build
		option = opreq.options.build
		
	end

	def create 
		@institution = Institution.new(params[:institution])
		@institution.save
		flash[:notice] = "Successfully Created Institution"
		redirect_to institutions_path
	end

	def edit
		@institution = Institution.find(params[:id])
	end

	def update
		@institution = Institution.find(params[:id])
		@institution.update_attributes(params[:institution])
		flash[:notice] = "Successfully updated Institution."
		redirect_to institutions_path
	end

	def destroy
		@institution = Institution.find(params[:id])
		@institution.destroy
		flash[:notice] = "Successfully destroyed institution."
		redirect_to institutions_path
	end

	def show
		@institution = Institution.find(params[:id])
	end
end