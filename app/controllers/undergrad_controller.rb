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

  end

  def majorsba
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
  end

  def courseSearch

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