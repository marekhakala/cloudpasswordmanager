class CreateAuthenticationProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :authentication_providers do |t|
      t.string :name, null: false, unique: true
      t.timestamps null: false
    end

    AuthenticationProvider.create(name: 'facebook')
    AuthenticationProvider.create(name: 'google_oauth2')
  end
end
