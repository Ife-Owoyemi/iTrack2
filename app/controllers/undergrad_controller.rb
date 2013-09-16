class UndergradController < ApplicationController
  respond_to :html, :json
  def minors
    # Defines current user as a shorter variable
    @user = current_user
    
    # Temporary
    ###################################################################################################################################
    # Retrieves all the user course hashes for calculating completion for this page
    #@taken = @user.takenHash
    #@taking = @user.takingHash
    #@wtake = @user.wtakeHash
    #@user_courses = @user.usercoursesHash
    #@coursearray = @user.coursearray


    # Grabs the institution model: Should change based users instititution
    @achievementtype = Institution.modelscrap('Rice University', "Minors")
    
    # Function for creating the userhash to display on this page   
    @achievementtypehash, @taken, @taking, @user_courses, @coursearray, @cuser_courses = User.undergradfoldervar(@user, @achievementtype)
    @deps = @user_courses.keys
      @years = Year.find(:all, :conditions => ["user_id=?", current_user.id])#, :include => [ {:semesters => :usercourses}, :user ])
      @aps = current_user.aps.all
      @transfers = current_user.transfers.all
  end

  def majorsba
    if (current_user != nil)
      # Defines current user as a shorter variable
      @user = current_user
      
      # Temporary
      ###################################################################################################################################
      # Retrieves all the user course hashes for calculating completion for this page
      #@taken = @user.takenHash
      #@taking = @user.takingHash
      #@wtake = @user.wtakeHash
      #@user_courses = @user.usercoursesHash
      #@coursearray = @user.coursearray


      # Grabs the institution model: Should change based users instititution
      @achievementtype = Institution.modelscrap('Rice University', "BA")
      
      # Function for creating the userhash to display on this page   
      @achievementtypehash, @taken, @taking, @user_courses, @coursearray, @cuser_courses = User.undergradfoldervar(@user, @achievementtype)
      @deps = @user_courses.keys
      @years = Year.find(:all, :conditions => ["user_id=?", current_user.id])#, :include => [ {:semesters => :usercourses}, :user ])
      @aps = current_user.aps.all
      @transfers = current_user.transfers.all
    end
      
  end

  def majorsbas
    # Defines current user as a shorter variable
    @user = current_user

    # Temporary
    ###################################################################################################################################
    # Retrieves all the user course hashes for calculating completion for this page
    #@taken = @user.takenHash
    #@taking = @user.takingHash
    #@wtake = @user.wtakeHash
    #@user_courses = @user.usercoursesHash
    #@coursearray = @user.coursearray


    # Grabs the institution model: Should change based users instititution
    @achievementtype = Institution.modelscrap('Rice University', "BA-S")
    
    # Function for creating the userhash to display on this page   
    @achievementtypehash, @taken, @taking, @user_courses, @coursearray, @cuser_courses = User.undergradfoldervar(@user, @achievementtype)
    @deps = @user_courses.keys
      @years = Year.find(:all, :conditions => ["user_id=?", current_user.id])#, :include => [ {:semesters => :usercourses}, :user ])
      @aps = current_user.aps.all
      @transfers = current_user.transfers.all
  end

  def majorsbs
    # Defines current user as a shorter variable
    @user = current_user
    
    # Temporary
    ###################################################################################################################################
    # Retrieves all the user course hashes for calculating completion for this page
    #@taken = @user.takenHash
    #@taking = @user.takingHash
    #@wtake = @user.wtakeHash
    #@user_courses = @user.usercoursesHash
    #@coursearray = @user.coursearray


    # Grabs the institution model: Should change based users instititution
    @achievementtype = Institution.modelscrap('Rice University', "BS")
    
    # Function for creating the userhash to display on this page   
    @achievementtypehash, @taken, @taking, @user_courses, @coursearray, @cuser_courses = User.undergradfoldervar(@user, @achievementtype)
    @deps = @user_courses.keys
      @years = Year.find(:all, :conditions => ["user_id=?", current_user.id])#, :include => [ {:semesters => :usercourses}, :user ])
      @aps = current_user.aps.all
      @transfers = current_user.transfers.all
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