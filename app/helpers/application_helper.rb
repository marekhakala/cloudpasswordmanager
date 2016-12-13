module ApplicationHelper
  def full_title page_title
    base_title = "CloudPasswordManager"

    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def active_list_item is_active
    return "<li class=\"active\" style=\"width: 100%;\">".html_safe if is_active
    "<li style=\"width: 100%;\">".html_safe
  end

  def is_controller? controller
    return false unless params.has_key?(:controller)
    return params[:controller] == controller
  end

  def is_controller_action? controller, action
    return false unless params.has_key?(:controller)
    return false unless params.has_key?(:action)
    return (params[:controller] == controller and params[:action] == action)
  end

  def resolve_js_include
    return "application" unless params.has_key?(:controller)
    return "application_profile" if params[:controller] == "devise/registrations" and user_signed_in?
    return "application_static_pages" if params[:controller] == "static_pages"
    return "application_portal_users" if params[:controller] == "portal_users"
    return "application"
  end
end
