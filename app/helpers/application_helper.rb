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
    [ "admin" ].include?(role_name)
  end

  # Current customer and cart helpers
  def current_customer
    return nil unless defined?(current_user) && current_user
    @current_customer ||= Customer.find_by(user: current_user)
  end

  def current_cart
    return nil unless current_customer
    @current_cart ||= Cart.find_by(customer: current_customer)
  end

  def cart_item_count
    return 0 unless current_cart
    current_cart.cart_items.sum(:quantity)
  end
end
