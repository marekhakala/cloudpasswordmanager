module PortalUsersHelper
  def resolve_user_role role
    unless role.nil?
      case role.code
        when 'ADMIN1'
          "<i class=\"fa fa-user-circle\"></i>"
        when 'SUPERADMIN1'
          "<i class=\"fa fa-address-card\"></i>"
        else
          "<i class=\"fa fa-user\"></i>"
      end
    end
  end

  def resolve_user_role_label role
    output_html = ""
    output_html = resolve_user_role(role) + " <span class=\"hidden-xs\">" + role.label + "</span>" if not role.nil?
    output_html
  end

  def is_users_list_access_granted?
    return false if current_user.nil? or current_user.role.nil?

    case current_user.role.code
      when 'SUPERADMIN1'
        return true
      when 'ADMIN1'
        return true
      else
        return false
      end
  end

  def can_manage_role? role
    return false if current_user.nil? or current_user.role.nil?

    case current_user.role.code
      when 'SUPERADMIN1'
        return true if role.code != 'SUPERADMIN1'
        return false
      when 'ADMIN1'
        return true if role.code == 'USER1'
        return false
      else
        return false
      end
  end

  def can_manage_role_by_id? role_id
    role = Role.find_by(id: role_id)
    return false if role.nil?
    can_manage_role? role
  end

  def resolve_roles
    output = Array.new

    Role.all.each do |role|
      output << [ role.label, role.id ] if can_manage_role? role
    end

    output
  end
end
