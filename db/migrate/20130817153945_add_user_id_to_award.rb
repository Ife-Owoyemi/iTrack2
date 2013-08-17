class AddUserIdToAward < ActiveRecord::Migration

	def up
		add_column :awards, :user_id, :integer
	end

	def down
		remove_column :awards, :user_id
	end

end
