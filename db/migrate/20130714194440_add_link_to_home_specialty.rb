class AddLinkToHomeSpecialty < ActiveRecord::Migration
  def change
  	add_column :specialties, :linkhome, :string
  end
end
