require 'rails_helper'

@product = Product.create(title: 'Ruby on Rails', description: 'Ruby Book', image_url: 'ruby.jpg', price: 9.00)

RSpec.describe "UserStories", type: :request do
  describe "The customer order process" do
    it "allows a user to order a book" do
    	# A user goes to the store index page
      get '/'
      assert_response :success
      assert_template "index"

      # The user selects a product, adding it to the cart
    	xml_http_request :post, '/line_items', product_id: @product.id
    	assert_response :success

    	cart = Cart.find(session[:cart_id])
			assert_equal 1, cart.line_items.size
			assert_equal @product, cart.line_items[0].product

			# The user then proceeds to checkout
			get "/orders/new"
			assert_response :success
			assert_template "new"

			# The user fills in the respective checkout form and submits the order
			post_via_redirect "/orders", order: { name: "Dave Thomas", address: "123 The Street", email: "dave@example.com", pay_type: "Check" }
			assert_response :success
			assert_template "index"
			cart = Cart.find(session[:cart_id])
			assert_equal 0, cart.line_items.size

			# verify that the database now contains only our new order
			orders = Order.all
			assert_equal 1, orders.size
			order = orders[0]

			# verify that order is the one just placed
			assert_equal "Dave Thomas", order.name
			assert_equal "123 The Street", order.address
			assert_equal "dave@example.com", order.email
			assert_equal "Check", order.pay_type
			assert_equal 1, order.line_items.size
			line_item = order.line_items[0]
			assert_equal @product, line_item.product

			# verify that the email is correctly addressed and has the expected subject line
			mail = ActionMailer::Base.deliveries.last
			assert_equal ["dave@example.com"], mail.to
			assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value assert_equal "Pragmatic Store Order Confirmation", mail.subject
		end

  end
end
