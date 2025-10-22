module ApplicationHelper
  # Returns true if the current user is an admin and owns the given product
  # Ownership is defined by Product belonging to an AdminUser (admins table),
  # and that AdminUser belongs_to the owning User.
  def can_manage_product?(product)
    return false unless defined?(current_user)
    return false unless current_user&.role&.name == "admin"

    owner_user_id = product.respond_to?(:admin_user) ? product.admin_user&.user_id : nil
    owner_user_id.present? && current_user.id == owner_user_id
  end

  # Returns true if the logged-in user is a business-type account
  # Recognizes role names like "business", "business owner", or "seller" (case-insensitive)
  def business_user?
    return false unless defined?(current_user)
    role_name = current_user&.role&.name&.downcase
    ["admin"].include?(role_name)
  end
end
