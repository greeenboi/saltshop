module Admin
  # Namespace for admin controllers and helpers.
  # The data model for admin users is `AdminUser` (mapped to the `admins` table).

  # Delegate common ActiveRecord class methods used in tests to AdminUser to maintain compatibility.
  def self.method_missing(method_name, *args, &block)
    if AdminUser.respond_to?(method_name)
      AdminUser.public_send(method_name, *args, &block)
    else
      super
    end
  end

  def self.respond_to_missing?(method_name, include_private = false)
    AdminUser.respond_to?(method_name, include_private) || super
  end
end
