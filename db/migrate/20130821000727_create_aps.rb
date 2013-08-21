class CreateAps < ActiveRecord::Migration
  def change
    create_table :aps do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
