class AdminOrderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_order_mailer.new_order_notification.subject
  #
  def new_order_notification(admin:, order:)
    @admin = admin
    @order = order
    # Items in this order that belong to this admin
    @items_for_admin = @order.order_items.includes(:product).select { |oi| oi.product&.admin_id == @admin.id }

    mail to: @admin.user.email, subject: "New order ##{@order.id} placed"
  end
end
