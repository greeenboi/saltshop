require "test_helper"

class OrderNotificationsTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "sends admin notifications and customer confirmation" do
    customer = customers(:one)
    product1 = products(:one) # admin: one
    product2 = products(:two) # admin: two

    order = Order.create!(customer: customer, status: "pending")
    order.order_items.create!(product: product1, quantity: 1, price: product1.price)
    order.order_items.create!(product: product2, quantity: 2, price: product2.price)

    assert_difference -> { ActionMailer::Base.deliveries.size }, +3 do
      perform_enqueued_jobs do
        # Call the internal method directly to avoid after_commit behavior under transactional tests
        order.send(:send_notifications)
      end
    end

    recipients = ActionMailer::Base.deliveries.last(3).map { |m| m.to }.flatten

    # Admin one and two should each receive one email
    assert_includes recipients, users(:one).email
    assert_includes recipients, users(:two).email

    # Customer (user one) should also receive a confirmation, resulting in user one receiving two emails total
    assert_equal 2, recipients.count(users(:one).email)
    assert_equal 1, recipients.count(users(:two).email)
  end
end
