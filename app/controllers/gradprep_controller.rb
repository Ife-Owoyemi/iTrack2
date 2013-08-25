class GradprepController < ApplicationController
  respond_to :html, :json
  def premed
    @years = current_user.years.all
    @aps = current_user.aps.all
    @transfers = current_user.transfers.all
    @institution = Institution.where(:name => "Rice University")
    @achievementtype = @institution.where(:achievementtype => "Pre-med") 
    @institution.each do |type| 
      a = type.achievementtypes.all
      a.each do |t|
        if t.achievementtype == "Pre-med" 
          @premed = t
        end
      end 
    end
  end
end