class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :code, null: false, unique: true
      t.string :label, null: false
      t.string :description, null: true

      t.timestamps null: false
    end
  end
end
