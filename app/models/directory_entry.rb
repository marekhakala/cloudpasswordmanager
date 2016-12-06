class DirectoryEntry < ApplicationRecord
  belongs_to :user
  belongs_to :directory_entry
  has_many :directory_entries, dependent: :destroy
  has_many :password_entries, dependent: :destroy

  validates :label, presence: true
  validates :user, presence: true
end
