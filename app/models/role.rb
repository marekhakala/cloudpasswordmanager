class Role < ApplicationRecord
  has_many :users, :dependent => :nullify

  validates :code, presence: true, uniqueness: true
  validates :label, presence: true
end
