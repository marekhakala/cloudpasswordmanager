class UserSerializer < BaseSerializer
  attributes :fullname, :email, :address, :role,
  :current_sign_in_at, :current_sign_in_ip,
  :last_sign_in_at, :last_sign_in_ip, :created_at

  def role
    resolve_reference(object.role).as_json['role']
  end
end
