class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
  end
end
