class User < ApplicationRecord
  belongs_to :role

  has_many :directory_entries
  belongs_to :root_directory, class_name: 'DirectoryEntry', dependent: :destroy
  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy

  validates :fullname, presence: true
  validates :role, presence: true

  def self.create_from_omniauth params
    self.create_user({ fullname: params['info']['name'],
       email: params['info']['email'], password: Devise.friendly_token })
  end

  def self.create_user attrs
    self.create_base_user({ fullname: attrs[:fullname], email: attrs[:email],
       password: attrs[:password], role: Role.where(code: 'USER1').first })
  end

  def self.create_base_user attrs
    user_object = create(fullname: attrs[:fullname], email: attrs[:email],
                  password: attrs[:password], role: attrs[:role])

    user_object.root_directory = self.create_root_directory(user_object)
    user_object.save!
    user_object.root_directory.user = user_object
    user_object.root_directory.save!
    user_object
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable,
         :omniauth_providers => [:google_oauth2, :facebook]

  def self.create_root_directory user_object
    root_directory = DirectoryEntry.new
    root_directory.label = 'Root'
    root_directory.description = 'Root'
    root_directory.directory_entry = nil
    root_directory.user = user_object
    root_directory.save!

    root_directory
  end

  def is_current_user?
    return current_user == self
  end
end
