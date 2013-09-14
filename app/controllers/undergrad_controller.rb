class UndergradController < ApplicationController
  respond_to :html, :json
  def minors
    @user = current_user
    @taken = @user.takenHash
    @taking = @user.takingHash
    @wTake = @user.wtakeHash
    @user_courses = @user.usercoursesHash
    @coursearray = @user.coursearray

    @deps = @user_courses.keys

    @years = current_user.years.all
    @aps = current_user.aps.all
    @transfers = current_user.transfers.all
    @institution = Institution.find(:all, :conditions => ["name=?", 'Rice University'])

    @institution.each do |type| 
      a = type.achievementtypes.all
      a.each do |t|
        if t.achievementtype == "Minors" 
          @minors = t
        end
      end 
    end
    @b = @minors.colleges.all    
  end

  def majorsba
    if (current_user != nil)
      #@years = current_user.years.all
      #@tabNum = 0
      @user = current_user
      @taken = @user.takenHash
      @taking = @user.takingHash
      @wTake = @user.wtakeHash
      @user_courses = @user.usercoursesHash
      @coursearray = @user.coursearray

      @deps = @user_courses.keys

      @years = Year.find(:all, :conditions => ["user_id=?", current_user.id])#, :include => [ {:semesters => :usercourses}, :user ])
      @aps = current_user.aps.all
      @transfers = current_user.transfers.all
      #@institution = Institution.where(:name => "Rice University")    
      @institution = Institution.find(:all, :conditions => ["name=?", 'Rice University'])#, :include => [ {:achievementtypes => {:colleges =>  {:achievementnames => {:specialties => [:corereqs => :ccourses, :opreqs => {:options => :ocourses }, :groupopreqs => {:groups => {:options => :ocourses} }   ] }   } } } ])

      @institution.each do |type| 
        a = type.achievementtypes.all
        a.each do |t|
          if t.achievementtype == "BA" 
            @majorsba = t
          end
        end 
      end
      @b = @majorsba.colleges.all
    end
  else
    redirect_to signin_path
  end
end

  def majorsbas
    @user = current_user
    @taken = @user.takenHash
    @taking = @user.takingHash
    @wTake = @user.wtakeHash
    @user_courses = @user.usercoursesHash
    @coursearray = @user.coursearray

    @deps = @user_courses.keys

    @years = current_user.years.all
    @institution = Institution.find(:all, :conditions => ["name=?", 'Rice University'])
    @aps = current_user.aps.all
    @transfers = current_user.transfers.all
    #@institution = Institution.where(:name => "Rice University")

    @institution.each do |type| 
      a = type.achievementtypes.all
      a.each do |t|
        if t.achievementtype == "BA-S" 
          @majorsbas = t
        end
      end 
    end
    @b = @majorsbas.colleges.all
  end

  def majorsbs
    @user = current_user
    @taken = @user.takenHash
    @taking = @user.takingHash
    @wTake = @user.wtakeHash
    @user_courses = @user.usercoursesHash
    @coursearray = @user.coursearray

    @deps = @user_courses.keys

    @years = current_user.years.all
    @aps = current_user.aps.all
    @transfers = current_user.transfers.all
    @institution = Institution.find(:all, :conditions => ["name=?", 'Rice University'])

    @institution.each do |type| 
      a = type.achievementtypes.all
      a.each do |t|
        if t.achievementtype == "BS" 
          @majorsbs = t
        end
      end 
    end
    @b = @majorsbs.colleges.all
  end

  def courseSearch
    @num = params[:qCourse][:num]
    @dep = params[:qCourse][:dep]
    if (Usercourse.semesterCourseExistsByDepNum?(@dep,@num) == true)
      @foundCourses = true # variable to let view know what to show
      @usercourses = Usercourse.findByNumAndDep(@num,@dep) # find the course

      # collect stats for a course
      @averageHoursPerWeek = 0
      @count = @usercourses.count
      @usercourses.each do |course|
        if (course.hpweek != nil)
          @averageHoursPerWeek = @averageHoursPerWeek + course.hpweek
        else
          @averageHoursPerWeek = @averageHoursPerWeek + 3
        end
      end
      @averageHoursPerWeek = @averageHoursPerWeek/@count



    else
      @foundCourses = false
    end
    respond_to do |format|
      format.js
    end

  end

=begin
  
  def switchTabMajorsBa
    @tabNum = params[:tabNum]
    respond_to do |format|
      format.html {redirect_to root_path}
      format.js { render :locals => {:tabNum => @tabNum} }
    end
  end

=end

end