class AddAdvisorToHomeSpecialty < ActiveRecord::Migration
  def change
  	add_column :specialties, :advisor, :string
  end
end
