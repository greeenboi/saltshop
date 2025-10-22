class OrderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject
  #
  def order_confirmation(order:)
    @order = order
    @customer = @order.customer
    @user = @customer&.user

    recipient = @user&.email
    return if recipient.blank?

    mail to: recipient, subject: "Your order ##{@order.id} confirmation"
  end
end
