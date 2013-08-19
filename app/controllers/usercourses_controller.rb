class UsercoursesController < ApplicationController

=begin
	def  create
		@user = current_user.id
		@usercouse = Usercourse.new(params[:usercouse])
		if (@usercouse.save)
			flash[:success] = "New Course Added!"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.js
			end
		else
			@errors = @usercourse.errors.full_messages
			flash[:alert] = @errors
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end
=end

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
