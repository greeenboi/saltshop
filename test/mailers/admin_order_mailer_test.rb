# file: 'test/mailers/admin_order_mailer_test.rb'
require "test_helper"

class AdminOrderMailerTest < ActionMailer::TestCase
  test "new_order_notification sends to the admin owning items in the order" do
    admin_user = User.create!(username: "admin1", email: "admin1@example.test", password: "Password1!")
    admin = AdminUser.create!(user: admin_user)

    product = Product.create!(name: "Widget", price: 9.99, stock: 10, admin: admin)

    customer_user = User.create!(username: "cust1", email: "cust1@example.test", password: "Password1!")
    customer = Customer.create!(user: customer_user)

    order = Order.create!(customer: customer, status: "pending")
    OrderItem.create!(order: order, product: product, quantity: 2, price: product.price)

    mail = AdminOrderMailer.new_order_notification(admin: admin, order: order)

    assert_equal [admin_user.email], mail.to
    assert_match "order", mail.subject.downcase
    assert_match "Widget", mail.body.encoded
  end
end
