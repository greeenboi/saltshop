# file: 'test/models/order_notifications_test.rb'
require "test_helper"

class OrderNotificationsTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "enqueues one email per unique admin and one to the customer" do
    admin1_user = User.create!(username: "admin1", email: "admin1@example.test", password: "Password1!")
    admin2_user = User.create!(username: "admin2", email: "admin2@example.test", password: "Password1!")
    admin1 = AdminUser.create!(user: admin1_user)
    admin2 = AdminUser.create!(user: admin2_user)

    p1 = Product.create!(name: "A", price: 5, stock: 10, admin: admin1)
    p2 = Product.create!(name: "B", price: 7, stock: 10, admin: admin2)

    cust_user = User.create!(username: "cust", email: "cust@example.test", password: "Password1!")
    customer = Customer.create!(user: cust_user)

    order = Order.create!(customer: customer, status: "pending")
    OrderItem.create!(order: order, product: p1, quantity: 1, price: 5)
    OrderItem.create!(order: order, product: p2, quantity: 2, price: 7)

    perform_enqueued_jobs do
      # trigger callbacks explicitly in case transactional tests suppress after_commit
      order.send(:send_notifications)
    end

    # Expect 3 emails: admin1, admin2, customer
    deliveries = ActionMailer::Base.deliveries.last(3)
    tos = deliveries.flat_map(&:to)
    assert_includes tos, [admin1_user.email]
    assert_includes tos, [admin2_user.email]
    assert_includes tos, [cust_user.email]
  end
end
