require File.expand_path('../boot', __FILE__)
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myshop
  class MyExpresslyProvider  < Expressly::MerchantPluginProvider
    def initialize()
      @customers = {}
    end

    def popup_handler(controller, campaign_customer_uuid)
      controller.flash[:campaign_customer_uuid] = campaign_customer_uuid
      controller.redirect_to "/welcome/index"
    end

    def customer_register(primary_email, customer)
      # persist this to the database
      @customers[primary_email] = customer

      # the value you return here will be used in further calls
      # as the parameter labelled customer_reference, we are
      # using the email here but you could just as easily use
      # the database identifier or the customer object itself
      return primary_email
    end

    def customer_send_password_reset_email(customer_reference)
      # reset the customers password and send them an email
      # so that they will be able to login in future
    end

    def customer_update_cart(customer_reference, cart)
      if !blank?(cart.coupon_code)
        # add the coupon to the customer's cart
      end
      if !blank?(cart.product_id)
        # add the product to the customer's cart
      end
    end

    def customer_login(customer_reference)
      # log the customer's session in. the reference is the one
      # you returned from customer_register
    end

    def customer_migrated_redirect_url(success, customer_reference = nil)
      return "/welcome/index"
    end

    def get_customer(email)
      return @customers[email] if !@customers[email].nil?

      # the customer doesn't exist in our fake db but we'll just create
      # one anyway for the fun of it
      customer = Expressly::Customer.new({
        :first_name => 'First',
        :last_name => 'Last',
        :gender =>  Expressly::Gender::Male,
        :billing_address_index => 0,
        :shipping_address_index => 1,
        :company_name => 'Company',
        :date_of_birth => Date.parse('1975-08-14'),
        :tax_number => 'Tax#',
        :last_updated => DateTime.now,

        :online_identity_list => [
        Expressly::OnlineIdentity.new({ :type =>  Expressly::OnlineIdentityType::Twitter, :identity => '@ev' }),
        Expressly::OnlineIdentity.new({ :type =>  Expressly::OnlineIdentityType::Facebook, :identity => 'fb.ev' })],

        :phone_list => [
        Expressly::Phone.new({ :type =>  Expressly::PhoneType::Work, :number => '12345' }),
        Expressly::Phone.new({ :type =>  Expressly::PhoneType::Mobile, :number => '56789' })],

        :email_list => [
        Expressly::EmailAddress.new({ :email => 'alt1@test.com', :alias => 'personal' }),
        Expressly::EmailAddress.new({ :email => 'alt2@test.com', :alias => 'work' })],

        :address_list => [
        Expressly::Address.new({:first_name => 'f1', :address_1 => 'one'}),
        Expressly::Address.new({:first_name => 'f2', :address_1 => 'two'})],

        :last_order_date => Date.parse('2015-09-14'),
        :number_of_orders => 2
      })

      @customers[email] = customer
      return customer
    end

    def check_customer_statuses(email_list)
      statuses = Expressly::CustomerStatuses.new
      email_list.each do |email|

        # check if the email already exists in your customer database
        # if it does then add it to the response
        if !@customers[email].nil? then
          statuses.add_existing(email)
        end

        # if it doesn't you can also check if the email exists for
        # an unfinished registration
        # statuses.add_pending(email)

        # or if the customers account was
        # deleted
        # statuses.add_deleted(email)

        # otherwise if you've never seen the email then do nothing
      end
      return statuses
    end

    ##
    # Some documentation on the get_order_details method
    def get_customer_invoices(customer_invoice_request_list)
      invoices = []
      customer_invoice_request_list.each do |invoice_request|
        # check if customer has had any orders between invoice_request.from and invoice_request_to
        # if they have then create an invoice
        invoice = Expressly::CustomerInvoice.new(invoice_request.email)

        # add all the orders between the dates for the user
        # we're going to pretend there were two for each customer for illustration purposes
        order = create_fake_order(invoice_request.from, rand * 600, 1 + rand(5))
        invoice.add_order(order)

        order = create_fake_order(invoice_request.from, rand * 300, 1 + rand(2))
        invoice.add_order(order)

        invoices << invoice
      end
      return invoices
    end

    def blank?(obj)
      obj.nil? or obj == ""
    end

    def create_fake_order(date, amount, item_count)
      Expressly::CustomerOrder.new({
        :order_id => "order#{rand(100000)}",
        :order_date => date,
        :item_count => item_count,
        :coupon_code => 'coupon',
        :currency => 'GBP',
        :pre_tax_total => amount,
        :tax => amount * 0.2,
        :post_tax_total => amount * 1.2 })
    end

  end

  class Application < Rails::Application
    config.active_record.raise_in_transactional_callbacks = true

    Expressly.default_configuration = Expressly::Configuration.new(
      'your_expressly_api_key',
      MyExpresslyProvider.new,
      'https://myshop.com/',
      { :locale => 'en_GB' })
  end
end

require 'expressly'
