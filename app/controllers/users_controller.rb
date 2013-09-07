include UsersHelper
include SessionsHelper
class UsersController < ApplicationController
  respond_to :json, :html, :xml, :js
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  def new
  	@user = User.new
  end

  def show
    @ucatalog = Hash.new
    @ucatalog["di"] = Hash.new
    @ucatalog["dii"] = Hash.new
    @ucatalog["diii"] = Hash.new
    @courses = Catalog.all
    @ucatalog = Catalog.distributionbuilder(@courses)
    
    if signed_in? == false
      redirect_to signin_path
    elsif (params[:id] != nil)
      @user = User.find(params[:id])

      @institution = Institution.where(:name => "Rice University")  
      @awards = @user.awards.all
      @internships = @user.internships.all
      @conferences = @user.conferences.all

      @cuser_courses = User.usercourses(@user) 

      #@variable = User.sampleFunction1(@user)
      @microposts = @user.microposts.paginate(page: params[:page])
      @years = @user.years.all
      @aps = @user.aps.all
      @transfers = @user.transfers.all


      


    elsif current_user == nil
        redirect_to signin_path

      
    elsif (params[:id] == nil && signed_in? == true) 
      @user = current_user
      @taken, @taking, @wtake, @user_courses, @coursearray = User.courseHashArrayGenerator(@user)

      @achievementtypes = @user.userachievementtypes.all
      @institution = Institution.where(:name => "Rice University")  
      @awards = @user.awards.all
      @internships = @user.internships.all
      @conferences = @user.conferences.all 
      @user = current_user
      @cuser_courses = User.usercourses(@user)
      #@variable = User.sampleFunction1(@user)

      @microposts = @user.microposts.paginate(page: params[:page])
      @years = @user.years.all
      @aps = @user.aps.all
      @transfers = @user.transfers.all
      @achievementtypes = @user.userachievementtypes.all
      @institution = Institution.where(:name => "Rice University")
      @awards = @user.awards.all
      @internships = @user.internships.all            
      @conferences = @user.conferences.all





    end
    @achievementtypes = @user.userachievementtypes.all
    @achievementhash = Userachievementtype.achievementhashgenerator(@achievementtypes)
    @achievement = Institution.achievementmodelfetcher(@institution, @achievementhash)
    
    @studentachievementhash = User.studentachievementhashgenerator(@achievement, @achievementhash, @taken, @taking, @wtake)
    # Prepare @studentspecialty

    # Planning to move to User Modelsg

  end

=begin
  
  def show_current_user
    if (current_user != nil)    
      @courses = Catalog.all
      @user = current_user
      @microposts = @user.microposts.paginate(page: params[:page])
      @years = @user.years.all
      @achievementtypes = @user.userachievementtypes.all
      @institution = Institution.where(:name => "Rice University")
      redirect_to user_path()
    else
      redirect_to signin_path
    end
  end

=end


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
        format.json { render :json => {:errors => @errors, :status => 422} }
      end
    end
  end

  def search
    q = params[:user_search][:q]
    searchType = params[:user_search][:qType]
    status = params[:user_search][:status]
    @institution = Institution.where(:name => "Rice University") 
    @qresults = User.railSearchBy(q, searchType)#.results   
    if (status == "Undergrad")
      @users = User.findUndergrads(@qresults)
    elsif (status == "Alumni")
      @users = User.findAlumi(@qresults)
    elsif (status == "Prospective Student")
      @users = User.findProspStu(@qresults)
    else
      @users = @qresults.paginate(:page => 1, :per_page => 10)
    end

  end

  def search_by_achievement
    q = params[:ach_search][:q]
    searchType = params[:ach_search][:qType]
    status = params[:ach_search][:status]    
    @institution = Institution.where(:name => "Rice University") 
    @qresults = Userachievementtype.railSearchBy(q,searchType)#.results
    @qusers = Userachievementtype.findUsers(@qresults)
    if (status == "Undergrad")
      @users = User.findUndergrads(@qusers)
    elsif (status == "Alumni")
      @users = User.findAlumi(@qusers)
    elsif (status == "Prospective Student")
      @users = User.findProspStu(@qusers)
    else
      @users = @qusers.paginate(:page => 1, :per_page => 10)
    end        
  end

  def uploadTranscript
    current_user.transcriptReader(params[:transcript][:file])
    flash[:notice] = "Transcript updated!"
    redirect_to root_path
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
