class AddNoteToSpecialty < ActiveRecord::Migration
  def change
  	add_column :specialties, :notes, :text
  end
end
