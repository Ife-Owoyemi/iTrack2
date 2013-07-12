class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.integer :colege_id
      t.string :departmentabbr
      t.string :departmentname

      t.timestamps
    end
  end
end
