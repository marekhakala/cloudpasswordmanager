class CreateDirectoryEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :directory_entries do |t|
      t.string :label, null: false, index: true
      t.text :description, null: true

      t.references :directory_entry, null: true, index: true, foreign_key: true
      t.references :user, null: false, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
