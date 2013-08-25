class UndergradController < ApplicationController
  respond_to :html, :json
  def minors
    @years = current_user.years.all
    @aps = current_user.aps.all
    @transfers = current_user.transfers.all
    @institution = Institution.where(:name => "Rice University")
    @institution.each do |type| 
      a = type.achievementtypes.all
      a.each do |t|
        if t.achievementtype == "Minors" 
          @minors = t
        end
      end 
    end    
  end

  def majorsba
    #@years = current_user.years.all
    @years = Year.find(:all, :conditions => ["user_id=?", current_user.id], :include => [ {:semesters => :usercourses}, :user ])
    @aps = current_user.aps.all
    @transfers = current_user.transfers.all
    #@institution = Institution.where(:name => "Rice University")    
    @institution = Institution.find(:all, :conditions => ["name=?", 'Rice University'], :include => [ {:achievementtypes => {:colleges =>  {:achievementnames => {:specialties => { :corereqs => :ccourses } }   } } } ])
    @institution.each do |type| 
      a = type.achievementtypes.all
      a.each do |t|
        if t.achievementtype == "BA" 
          @majorsba = t
        end
      end 
    end
  end

  def majorsbas
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
  end

  def majorsbs
    @years = current_user.years.all
    @aps = current_user.aps.all
    @transfers = current_user.transfers.all
    @institution = Institution.where(:name => "Rice University")
    @institution.each do |type| 
      a = type.achievementtypes.all
      a.each do |t|
        if t.achievementtype == "BS" 
          @majorsbs = t
        end
      end 
    end
  end


end