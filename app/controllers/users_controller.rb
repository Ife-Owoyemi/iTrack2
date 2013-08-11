class UsersController < ApplicationController
  respond_to :json, :html, :xml, :js
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  def new
  	@user = User.new
  end

  def show
    @courses = Catalog.all
  	@user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @years = @user.years.all
    @achievementtypes = @user.userachievementtypes.all
    @institution = Institution.where(:name => "Rice University")
    
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def index
    @institution = Institution.where(:name => "Rice University")
    @users = User.paginate(page: params[:page])
  end

  def create
  	@user = User.new(params[:user])
  	if@user.save
      sign_in @user
  		flash[:success] = "Welcome to the iTrack!"
  		redirect_to @user# Handle a successful save.
  	else
  		render 'new'
  	end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def edit 
    @user = current_user
    @institution = Institution.where(:nickname => current_user.college)
    
  end

  def edituser
    @user = current_user
    @institution = Institution.where(:nickname => current_user.college)
  end

  def edittrack
    @user = current_user
    @institution = Institution.where(:nickname => current_user.college)
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end

  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
