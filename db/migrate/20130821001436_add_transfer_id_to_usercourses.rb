class AddTransferIdToUsercourses < ActiveRecord::Migration

	def up
		add_column :usercourses, :transfer_id, :integer
	end

	def down 
		rmeove_column :usercourses, :transfer_id
	end

end
