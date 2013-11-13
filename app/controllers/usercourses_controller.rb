class UsercoursesController < ApplicationController

	def  create
		@user = current_user
		@usercouse = Usercourse.new(params[:usercourse])
		if (@usercouse.save)
			User.initSerialHashesForUser(current_user)
			expire_fragment('achievementtypehash_for_hash') # cache update 
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
		@institution = Institution.find(:first, :conditions => ["name=?", 'Rice University']).id
		pyear = params[:usercourse][:year].to_i
		psemester = params[:usercourse][:semester]
		@department = params[:usercourse][:department]
		@num = params[:usercourse][:num]
		grade = params[:usercourse][:grade]
		credits = params[:usercourse][:credits].to_i

		if ( Year.userYearExists?(current_user.id,pyear) == true )
			year = Year.findYear(current_user.id,pyear)
		else
			year = current_user.create!(:year => pyear)
		end

		if ( Semester.userSemesterExists?(year.id, psemester) )
			semester = Semester.findSemester(year.id,psemester)
		else
			semester = year.semesters.create!(:semester => psemester)
		end

		if (Usercourse.semesterCourseExists?(semester.id,@department,@num) )
			respond_to do |format|
				format.js {render :js => "alert('Class already exists in your transcript')"}
			end
		else	
			@usercourse = Usercourse.createSemesterCourseFromTracks(semester,@department,@num,credits,grade)
			if (@usercourse.save)
				expire_fragment('achievementtypehash_for_hash') # cache update 
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
	end

	def deleteUsercourseFromHome
		@num = params[:num]
		@dep = params[:dep]
		@semester_id = params[:semester_id]
		if (Usercourse.semesterCourseExists?(@semester_id,@dep,@num))
			@course = Usercourse.findSemesterCourseByDepAndNum(@semester_id,@dep,@num)
			@course.destroy
			expire_fragment('achievementtypehash_for_hash') # cache update 
			flash[:success] = "Course Deleted"
		end
		redirect_to root_path
		#respond_to do |format|
		#	format.html {redirect_to root_path}
			#format.js 
		#end

	end

	def update
		@usercourse = Usercourse.find(params[:id])
		if (@usercourse.update_attributes!(params[:usercourse]))
			expire_fragment('achievementtypehash_for_hash') # cache update 
			flash[:success] = "Course Update was a success"
			respond_to do |format|
				format.html { redirect_to root_path }
				format.json {respond_with_bip(@usercourse)}
			end
		else
			@errors = @usercourse.errors.full_messages
			flash[:warning] = @errors
			respond_to do |format|
				format.html {redirect_to root_path}
				format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end


end
