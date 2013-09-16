class Specialty < ActiveRecord::Base
  attr_accessible :achievementname_id, :specialty, :corereqs_attributes, :opreqs_attributes, :groupopreqs_attributes, :depnumreqs_attributes, :notes, :advisor, :linkhome
  belongs_to :achievementname
  has_many :corereqs, dependent: :destroy
  has_many :opreqs, dependent: :destroy
  has_many :groupopreqs, dependent: :destroy
  has_many :depnumreqs, dependent: :destroy
  accepts_nested_attributes_for :corereqs, :allow_destroy => true
  accepts_nested_attributes_for :opreqs, :allow_destroy => true
  accepts_nested_attributes_for :groupopreqs, :allow_destroy => true
  accepts_nested_attributes_for :depnumreqs, :allow_destroy => true

  #Produces 
  #Courses taken or plan to be taken within a specialty - For calculating major gpa, and displaying completion when courses are listed
  #A hash copy of the model structure for looping through and displaying
  # Other things that would be useful: calculating the number of courses left, 
  def self.calculate(specialty, taken, taking, wtake)
    @specialtyHash = Hash.new
    @specialtyHash[:core] = Hash.new
    @specialtyHash[:op] = Hash.new
    @specialtyHash[:depnum] = Hash.new
    arrayOfUsedCourses = Array.new
    @totalc = 0
    @takent = 0 
    @takingt = 0
    @wtaket = 0 
    @core_c_1 = 0
    @core_c_2 = 0
    @core_c_3 = 0
    @used_courses = Array.new

    corereqmArray = specialty.corereqs.all
    for corereq in corereqmArray
      @totalc += corereq.cgoal.to_i
      courseArray = corereq.ccourses.all
      #Collect courses within every requirement for displaying in show
      @specialtyHash[:core][corereq.corereqname] = Hash.new
      #Collect courses within every requirement for displaying in show
      @specialtyHash[:core][corereq.corereqname][:courseslisted] = Array.new
      for course in courseArray
        @specialtyHash[:core][corereq.corereqname][:courseslisted] << course.department + " " + course.num.to_s
        @core_c_1, @used_courses = Corereq.coreclasschecker(taken, course, @used_courses, @core_c_1)
        @core_c_2, @used_courses = Corereq.coreclasschecker(taking, course, @used_courses, @core_c_2)
        @core_c_3, @used_courses = Corereq.coreclasschecker(wtake, course, @used_courses, @core_c_3)
      end
      @specialtyHash[:core][corereq.corereqname][:complete] = @core_c_1 + @core_c_2 + @core_c_3

    end
    @op_c = 0
    @op_c_1 = 0 # => sumTakenCourseCompleteOptRequirement = 0 # => @op_c_1
    @op_c_2 = 0 # => sumTakingCourseCompleteOptRequirement = 0 # => @op_c_2
    @op_c_3 = 0 # => sumWillTakeCourseCompleteOptRequirement = 0 # => @op_c_3
    opReqArray = specialty.opreqs.all
    for opreq in opReqArray
      
      unknownVariable = 0 # => complete
      optionArray = opreq.options.all
      @specialtyHash[:op][opreq.opreqname] = Hash.new
      @optioncount = 0
      @op_add = 0 # => tempOpLimit = 0 # @op_add
      @op_c_big = 0 # => tempAllOpReqCompletion = 0 # => @op_c_big
      @op_c_big_1 = 0 # => tempSumTakenCourseCompleteOptRequirement2 = 0 # => @op_c_big_1
      @op_c_big_2 = 0 # => tempSumTakingCourseCompleteOptRequirement2 = 0 # => @op_c_big_2
      @op_c_big_3 = 0 # => tempSumWillTakeCourseCompleteOptRequirement2 = 0 # => @op_c_big_3
      @op_c_biggest = 0 # => opCompletionTempHolder = 0 # => @op_c_biggest
      for option in optionArray
        @specialtyHash[:op][opreq.opreqname][@optioncount] = Hash.new
        @specialtyHash[:op][opreq.opreqname][@optioncount][:name] = option.optionname
        

        sumOptionCourses = 0 # => op_c_all
        
        @op_c_m = 0 # => tempSumAllCourseCompleteOptRequirement = 0 # => @op_c_m
        @op_c_m_1 = 0 # => tempSumTakenCourseCompleteOptRequirement = 0 # => @op_c_m_1
        @op_c_m_2 = 0 # => tempSumTakingCourseCompleteOptRequirement = 0 # => @op_c_m_2
        @op_c_m_3 = 0 # => tempSumWillTakeCourseCompleteOptRequirement = 0 # => @op_c_m_3
        
        
        courseArray = option.ocourses.all
        @specialtyHash[:op][opreq.opreqname][@optioncount][:courseslisted] = Array.new
        for course in courseArray
          @specialtyHash[:op][opreq.opreqname][@optioncount][:courseslisted] << course.department + " " + course.num.to_s
          arrayOfUsedCourses, @op_c_m, @op_c_m_1 = Opreq.optionclasschecker(taken, course, @used_courses, @op_c_m, @op_c_m_1)
          arrayOfUsedCourses, @op_c_m, @op_c_m_2 = Opreq.optionclasschecker(taking, course, @used_courses, @op_c_m, @op_c_m_2)
          arrayOfUsedCourses, @op_c_m, @op_c_m_3 = Opreq.optionclasschecker(wtake, course, @used_courses, @op_c_m, @op_c_m_3)
        end
        @op_add,@op_c_biggest, @op_c_big, @op_c_big_1, @op_c_big_2, @op_c_big_3 = Opreq.optiondataevaluator(option, @op_add, @op_c_big, @op_c_biggest, @op_c_m,  @op_c_m_1,@op_c_m_2, @op_c_m_3, @op_c_big_1,@op_c_big_2, @op_c_big_3)
        @optioncount += 1
      end
      if @op_c_big != nil
        @op_c += @op_c_big
      else
        @op_c_big = 0

      end

      @totalc += @op_add
      @op_c_1 += @op_c_big_1
      @op_c_2 += @op_c_big_2
      @op_c_3 += @op_c_big_3
      @specialtyHash[:op][opreq.opreqname][:progress] = @op_c_big.to_s + "/" + @op_add.to_s
      if @op_c_big == @op_add
        @specialtyHash[:op][opreq.opreqname][:complete] = true
      else
        @specialtyHash[:op][opreq.opreqname][:complete] = false
      end  
    end
    #New Algorithm
    groupOpReqArray = specialty.groupopreqs.all
    for groupOpReq in groupOpReqArray
      groupArray = groupOpReq.groups.all
      for group in groupArray
        optionArray = group.options.all
        for option in optionArray
          courseArray = option.ocourses.all
          for course in courseArray
            #count the amount of courses completed by comparing with taken,taking, and wtake
          end
          #check if the optiongoal has been completed
        end
        #check how many options have been completed
      end
      # see how many groups have been completed.

    end

    

    # define varialbe for depnumreq calculations
    @dep_c_m_1 = 0
    @dep_c_m_2 = 0
    @dep_c_m_3 = 0
    @dep_c_1 = 0
    @dep_c_2 = 0
    @dep_c_3 = 0
    tempdepnumlimit = 0 # => @depnumgoal
    depNumReqArray = specialty.depnumreqs.all
    for depNumReq in depNumReqArray # depnumcalc => depNumReq 
      countedcourse = Array.new
      @specialtyHash[:depnum][depNumReq.depnumreqname]
      depsArray = depNumReq.deps.all
      if depNumReq.doublecount == "N"
        if depNumReq.hgoal == nil or depNumReq.hgoal == 0
          for dep in depsArray
            excepsModelArray = dep.cexceptions.all # => exceps
            exceptionsCourseList = arraycreator(excepsModelArray) # => excepsarray

            clistsModelArray = dep.clists.all # => clists
            clistsCourseList = arraycreator(clistsModelArray) # => clistarray
            boundsArray = dep.bounds.all # => gg

            @dep_c_m_1, countedcourse = Depnumreq.coursecounternodoublecount(taken, countedcourse, boundsArray, @dep_c_m_1, dep, exceptionsCourseList, clistsCourseList, @used_courses )
            @dep_c_m_2, countedcourse = Depnumreq.coursecounternodoublecount(taking, countedcourse, boundsArray, @dep_c_m_2, dep, exceptionsCourseList, clistsCourseList, @used_courses )
            @dep_c_m_3, countedcourse = Depnumreq.coursecounternodoublecount(wtake, countedcourse, boundsArray, @dep_c_m_3, dep, exceptionsCourseList, clistsCourseList, @used_courses)

          end
          @dep_c_m_1,@dep_c_m_2 ,@dep_c_m_3 = Depnumreq.correcting3partofwhole(@dep_c_m_1, @dep_c_m_2, @dep_c_m_3, depNumReq.cgoal.to_i)
          @totalc += depNumReq.cgoal
        elsif depNumReq.cgoal == nil or depNumReq.cgoal == 0
          for dep in depsArray
            excepsModelArray = dep.cexceptions.all # => exceps
            exceptionsCourseList = arraycreator(excepsModelArray) # => excepsarray

            clistsModelArray = dep.clists.all # => clists
            clistsCourseList = arraycreator(clistsModelArray)
            boundsArray = dep.bounds.all # => gg
            @dep_c_m_1, countedcourse = Depnumreq.hourcounternodoublecount(taken, countedcourse, boundsArray, @dep_c_m_1, dep, exceptionsCourseList, clistsCourseList, @used_courses )
            @dep_c_m_2, countedcourse = Depnumreq.hourcounternodoublecount(taking, countedcourse, boundsArray, @dep_c_m_2, dep, exceptionsCourseList, clistsCourseList, @used_courses )
            @dep_c_m_3, countedcourse = Depnumreq.hourcounternodoublecount(wtake, countedcourse, boundsArray, @dep_c_m_3, dep, exceptionsCourseList, clistsCourseList, @used_courses)

          end
          #correcting3partofwhole
          @totalc += depNumReq.cgoal
        end
      elsif depNumReq.doublecount == "Y"
        if depNumReq.hgoal == nil or depNumReq.hgoal == 0
          for dep in depsArray
            excepsModelArray = dep.cexceptions.all # => exceps
            exceptionsCourseList = Specialty.arraycreator(excepsModelArray) # => excepsarray

            clistsModelArray = dep.clists.all # => clists
            clistsCourseList = Specialty.arraycreator(clistsModelArray) # => clistarray
            boundsArray = dep.bounds.all # => gg

            @dep_c_m_1, countedcourse = Depnumreq.coursecounteryesdoublecount(taken, countedcourse, boundsArray, @dep_c_m_1, dep, exceptionsCourseList, clistsCourseList)
            @dep_c_m_2, countedcourse = Depnumreq.coursecounteryesdoublecount(taking, countedcourse, boundsArray, @dep_c_m_2, dep, exceptionsCourseList, clistsCourseList)
            @dep_c_m_3, countedcourse = Depnumreq.coursecounteryesdoublecount(wtake, countedcourse, boundsArray, @dep_c_m_3, dep, exceptionsCourseList, clistsCourseList)

          end
          @dep_c_m_1,@dep_c_m_2 ,@dep_c_m_3 = Depnumreq.correcting3partofwhole(@dep_c_m_1, @dep_c_m_2, @dep_c_m_3, depNumReq.cgoal.to_i)
          @totalc += depNumReq.cgoal
        elsif depNumReq.cgoal == nil or depNumReq.cgoal == 0
          for dep in depsArray
            excepsModelArray = dep.cexceptions.all # => exceps
            exceptionsCourseList = Specialty.arraycreator(excepsModelArray) # => excepsarray

            clistsModelArray = dep.clists.all # => clists
            clistsCourseList = Specialty.arraycreator(clistsModelArray)
            boundsArray = dep.bounds.all # => gg
            @dep_c_m_1, countedcourse = Depnumreq.hourcounteryesdoublecount(taken, countedcourse, boundsArray, @dep_c_m_1, dep, exceptionsCourseList, clistsCourseList)
            @dep_c_m_2, countedcourse = Depnumreq.hourcounteryesdoublecount(taking, countedcourse, boundsArray, @dep_c_m_2, dep, exceptionsCourseList, clistsCourseList)
            @dep_c_m_3, countedcourse = Depnumreq.hourcounteryesdoublecount(wtake, countedcourse, boundsArray, @dep_c_m_3, dep, exceptionsCourseList, clistsCourseList)

          end
          #correcting3partofwhole
          @totalc += depNumReq.cgoal
        end
      end
      @specialtyHash[:depnum][depNumReq.depnumreqname] = Hash.new
      @specialtyHash[:depnum][depNumReq.depnumreqname][:progress] = (@dep_c_m_1 + @dep_c_m_2 + @dep_c_m_3).to_s + "/" + depNumReq.cgoal.to_s
      if depNumReq.cgoal == (@dep_c_m_1 + @dep_c_m_2 + @dep_c_m_3) 
        @specialtyHash[:depnum][depNumReq.depnumreqname][:complete] = true
      else
        @specialtyHash[:depnum][depNumReq.depnumreqname][:complete] = false
      end 
      @specialtyHash[:depnum][depNumReq.depnumreqname][:usedcourses] = countedcourse
    end # depNumReq end

    

    
    # Final Sum
    @specialtyclassesleft = 0
    # Prevents bugs from incomplete models and saves calculating time
    if @totalc != 0 and @totalc != nil
      # Bug checking
      @op_c_1 = Specialty.nilcheck(@op_c_1)
      @op_c_2 = Specialty.nilcheck(@op_c_2)
      @op_c_3 = Specialty.nilcheck(@op_c_3)

      @core_c_1 = Specialty.nilcheck(@core_c_1)
      @core_c_2 = Specialty.nilcheck(@core_c_2)
      @core_c_3 = Specialty.nilcheck(@core_c_3)
      
      @specialtycoursestaken = @core_c_1 + @op_c_1 + @dep_c_1
      @specialtycoursestaking = @core_c_2 + @op_c_2 + @dep_c_2
      @specialtycourseswtake = @core_c_3 + @op_c_3 + @dep_c_3

      @takent = (@specialtycoursestaken * 100) / @totalc
      @takingt = (@specialtycoursestaking * 100) / @totalc
      @wtaket = (@specialtycourseswtake * 100) / @totalc
      @specialtyclassesleft = @totalc - (@specialtycoursestaken + @specialtycoursestaking + @specialtycourseswtake)
    else
      @specialtycoursestaken = 0
      @specialtycoursestaking = 0
      @specialtycourseswtake = 0
      @takent = 0
      @takingt = 0
      @wtaket = 0
    end
    # Saving the percent Completion
    @specialtyHash[:stats] = Hash.new
    @specialtyHash[:stats][:takent] = @takent
    @specialtyHash[:stats][:takingt] = @takingt
    @specialtyHash[:stats][:wtaket] = @wtaket
    @specialtyHash[:stats][:left] = @specialtyclassesleft
    @specialtyHash[:stats][:ctaken] = @specialtycoursestaken
    @specialtyHash[:stats][:ctaking] = @specialtycoursestaking
    @specialtyHash[:stats][:cwtake] = @specialtycourseswtake
    return @specialtyHash
  end
  def self.arraycreator(modelarray)
    array = Array.new
    for a in modelarray
      array << a.department + a.num.to_s
    end
    return array
  end
  def self.nilcheck(variable)
    if variable == nil
      variable = 0
    end
    return variable
  end
end
