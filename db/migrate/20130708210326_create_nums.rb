class CreateNums < ActiveRecord::Migration
  def change
    create_table :nums do |t|
      t.integer :department_id
      t.string :brief
      t.integer :credit
      t.boolean :di
      t.boolean :dii
      t.boolean :diii
      t.integer :number

      t.timestamps
    end
  end
end
