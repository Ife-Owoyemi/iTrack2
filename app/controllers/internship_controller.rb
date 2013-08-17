class InternshipController < ApplicationController


	def  create
		@user = User.find(params[:id])
		@internship = Internship.new(params[:internship])
		if (@internship.save)
			flash[:success] = "New Internship created!"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json {respond_with_bip(@internship)}
			end
		else
			@errors = @internship.errors.full_messages
			flash[:alert] = @errors
			respond_to do |format|
				format.html{redirect_to current_user}
				format.json {:errors => @errors}, :status => 422
			end
		end
	end

	def update
		@user = User.find(params[:id])
		@internship = Internship.find(params[:internship][:id])
		if (@internship.update_attributes(params[:internship]))
			flash[:success] = "Internship Update was a success"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json{respond_with_bip(@internship)}
			end
		else
			@errors = @internship.errors.full_messages
			flash[:warning] = @errors
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json {:errors => @errors}, :status => 422
			end
		end
	end

	def destroy 
		@user = User.find(params[:id])
		if (current_user?(@user))
			@internship = Internship.find(params[:internship][:id])
			@internship.destroy
			flash[:success] = "Deleted Internship"
			#respond_to do |format| # use this respond to once I understand what the structure of the frontend is. -Ife
			#	format.html {redirect_to current_user}
			#	format.js 
			#end
			redirect_to current_user
		else # not likely to happen because delete button should only appear if user == current_user
			flash[:alert] = "You do not have right credentials to delete this internship"
			redirect_to current_user
		end
	end


end
