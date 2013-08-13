class CreateCexceptions < ActiveRecord::Migration
  def change
    create_table :cexceptions do |t|
      t.integer :dep_id
      t.string :department
      t.integer :num

      t.timestamps
    end
  end
end
