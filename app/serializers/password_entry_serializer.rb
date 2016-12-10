class PasswordEntrySerializer < BaseSerializer
  attributes :id, :directory_id, :label, :description, :password, :account, :email, :url, :created_at

  def directory_id
    object.directory_entry.id
  end
end
