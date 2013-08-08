class UndergradController < ApplicationController
  respond_to :html, :json
  def minors
    @years = current_user.years.all
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
    @years = current_user.years.all
    @institution = Institution.where(:name => "Rice University")
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
    @institution = Institution.where(:name => "Rice University")
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