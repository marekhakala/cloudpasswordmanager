class CreateUserAuthentications < ActiveRecord::Migration[5.0]
  def change
    create_table :user_authentications do |t|
      t.string :uid
      t.string :token
      t.datetime :token_expires_at
      t.text :params

      t.references :user, null: false, index: true, foreign_key: true
      t.references :authentication_provider, null: false, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
