class CatalogsController < ApplicationController
  respond_to :html, :json
  def catalog
    @courses = Catalog.all
    
    
  end
end