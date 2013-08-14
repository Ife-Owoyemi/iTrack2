class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  def new
  	@user = User.new
  end

  def show
    @courses = Catalog.all
    if (params[:id] != nil)
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @microposts = @user.microposts.paginate(page: params[:page])
    @years = @user.years.all
    @achievementtypes = @user.userachievementtypes.all
    @institution = Institution.where(:name => "Rice University")
  end

  def show_current_user
    @courses = Catalog.all
    @user = current_user
    @microposts = @user.microposts.paginate(page: params[:page])
    @years = @user.years.all
    @achievementtypes = @user.userachievementtypes.all
    @institution = Institution.where(:name => "Rice University")
    redirect_to user_path()
  end  

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def index
    @institution = Institution.where(:name => "Rice University")
    @users = User.paginate(page: params[:page])
    # all current vals for email, name, college, dreamJob for search
    @allNames = User.allNames
    @allEmails = User.allEmails
    @allDreamJobs = User.allDreamJobs
    @allColleges = User.allColleges
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
      respond_to do |format|
        format.html {redirect_to @user}
        format.json {respond_with_bip(@user)}
      end
    else
      respond_to do |format|
        format.html {render 'edit'}
        format.json {respond_with_bip(@user)}
      end
    end
  end

  def search
    q = params[:user_search][:q]
    searchType = params[:user_search][:qType]
    status = params[:user_search][:status]
    @institution = Institution.where(:name => "Rice University") 
    @qresults = User.searchBy(q, searchType).results   
    if (status == "Undergrad")
      @users = User.findUndergrads(@qresults)
    elsif (status == "Alumni")
      @users = User.findAlumi(@qresults)
    elsif (status == "Prospective Student")
      @users = User.findProspStu(@qresults)
    else
      @users = @qresults
    end
  end

  def search_by_achievement
    q = params[:ach_search][:q]
    searchType = params[:ach_search][:qType]
    status = params[:ach_search][:status]    
    @institution = Institution.where(:name => "Rice University") 
    @qresults = Userachievementtype.searchBy(q,searchType).results
    @qusers = Userachievementtype.findUsers(@qresults)
    if (status == "Undergrad")
      @users = User.findUndergrads(@qusers)
    elsif (status == "Alumni")
      @users = User.findAlumi(@qusers)
    elsif (status == "Prospective Student")
      @users = User.findProspStu(@qusers)
    else
      @users = @qusers
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
