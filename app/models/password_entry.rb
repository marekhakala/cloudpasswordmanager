class PasswordEntry < ApplicationRecord
  belongs_to :directory_entry
  has_many :password_entries

  validates :label, presence: true
  validates :directory_entry, presence: true
end
