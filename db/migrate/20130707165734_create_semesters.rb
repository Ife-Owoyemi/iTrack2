class CreateSemesters < ActiveRecord::Migration
  def change
    create_table :semesters do |t|
      t.string :semester
      t.integer :year_id

      t.timestamps
    end
  end
end
