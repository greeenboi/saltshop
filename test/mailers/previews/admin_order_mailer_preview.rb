# Preview all emails at http://localhost:3000/rails/mailers/admin_order_mailer
class AdminOrderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/admin_order_mailer/new_order_notification
  def new_order_notification
    AdminOrderMailer.new_order_notification
  end
end
