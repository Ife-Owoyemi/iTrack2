class AwardController < ApplicationController

	def  create
		@user = current_user
		@award = Award.new(params[:award])
		if (@award.save)
			flash[:success] = "New Award created!"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.js
			end
		else
			@errors = @award.errors.full_messages
			flash[:alert] = @errors
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end

	def update
		@user = current_user
		if (@award.update_attributes(params[:award]))
			flash[:success] = "Award Update was a success"
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json{respond_with_bip(@award)}
			end
		else
			@errors = @award.errors.full_messages
			flash[:warning] = @errors
			respond_to do |format|
				format.html {redirect_to current_user}
				format.json { render :json => {:errors => @errors, :status => 422} }
			end
		end
	end

	def destroy 
		@user = User.find(params[:id])
		if (current_user?(@user))
			@award = Award.find(params[:award][:id])
			@award.destroy
			flash[:success] = "Deleted Award"
			#respond_to do |format| # use this respond to once I understand what the structure of the frontend is. -Ife
			#	format.html {redirect_to current_user}
			#	format.js 
			#end
			redirect_to current_user
		else # not likely to happen because delete button should only appear if user == current_user
			flash[:alert] = "You do not have right credentials to delete this award"
			redirect_to current_user
		end
	end

end
