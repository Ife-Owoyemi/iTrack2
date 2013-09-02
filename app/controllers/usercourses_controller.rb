class UsercoursesController < ApplicationController

	def  create
		@user = current_user
		@usercouse = Usercourse.new(params[:usercourse])
		if (@usercouse.save)
			flash[:success] = "New Course Added!"
			respond_to do |format|
				format.html {redirect_to current_user}
				#format.js
			end
		else
			@errors = @usercourse.errors.full_messages
			flash[:alert] = @errors
			respond_to do |format|
				format.html {redirect_to current_user}
				#format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end

	def createCourseModalJson
		@user = current_user
		@institution = params[:institution].first
		@department = params[:department]
		@num = params[:num]
		respond_to do |format|
			format.js
		end
	end

	def createFromModal
		@user = current_user

		pyear = params[:usercourse][:year].to_i
		if ( Year.userYearExists?(current_user.id,pyear) == true )
			year = Year.findYear(current_user.id,pyear)
		else
			year = current_user.create!(:year => pyear)
		end


		semester = params[:usercourse][:semester]


		department = params[:usercourse][:department]
		num = params[:usercourse][:num]
		grade = params[:usercourse][:grade]
		credits = params[:usercourse][:credits].to_i

		@usercourse = createSemesterCourseFromTracks(semester,department,num,credits,grade)
		if (@usercourse.save)
			flash[:success] = "New Course Added!"
			respond_to do |format| 
				format.js 
			end
		else
			@errors = @usercourse.errors.full_messages
			flash[:alert] = @errors
			respond_to do |format|
				format.js {render :js => "alert('Check the form for errors and then submit form.')"}
			end
		end
	end

	def update
		@usercourse = Usercourse.find(params[:id])
		if (@usercourse.update_attributes!(params[:usercourse]))
			flash[:success] = "Course Update was a success"
			respond_to do |format|
				format.html { redirect_to current_user }
				format.json {respond_with_bip(@usercourse)}
			end
		else
			@errors = @usercourse.errors.full_messages
			flash[:warning] = @errors
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end


end
