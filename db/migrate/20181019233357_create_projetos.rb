class CreateProjetos < ActiveRecord::Migration[5.1]
	def change
		create_table :projetos do |t|
			t.string :nome
			t.string :projeto
			t.string :url
			t.timestamps
		end
	end
end
