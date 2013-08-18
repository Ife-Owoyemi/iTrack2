class ConferenceController < ApplicationController

	def  create
		@user = current_user
		@conference = Conference.new(params[:conference])
		if (@conference.save)
			flash[:success] = "New conference created!"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json {respond_with_bip(@conference)}
			end
		else
			@errors = @conference.errors.full_messages
			flash[:alert] = @errors
			respond_to do |format|
				format.html{redirect_to current_user}
				format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end

	def update
		@user = current_user
		@conference = Conference.find(params[:conference][:id])
		if (@conference.update_attributes(params[:conference]))
			flash[:success] = "Conference Update was a success"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json{respond_with_bip(@conference)}
			end
		else
			@errors = @conference.errors.full_messages
			flash[:warning] = @errors
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end

	def destroy 
		#@user = current_user
		@user = User.find(params[:id])
		if (current_user?(@user))
			@conference = Conference.find(params[:conference][:id])
			@conference.destroy
			flash[:success] = "Deleted Conference"
			#respond_to do |format| # use this respond to once I understand what the structure of the frontend is. -Ife
			#	format.html {redirect_to current_user}
			#	format.js 
			#end
			redirect_to current_user
		else # not likely to happen because delete button should only appear if user == current_user
			flash[:alert] = "You do not have right credentials to delete this conference"
			redirect_to current_user
		end
	end

end
