class CreatePasswordEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :password_entries do |t|
      t.string :label, null: false, index: true
      t.text :description, null: true
      t.string :password, null: true
      t.string :account, null: true, index: true
      t.string :email, null: true, index: true
      t.string :url, null: true

      t.references :directory_entry, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
