require "rails_helper"

RSpec.describe OrderNotifier, type: :mailer do
  describe "received" do
    let(:mail) { OrderNotifier.received }

    it "renders the headers" do
      assert_equal "Pragmatic Store Order Confirmation", mail.subject
      assert_equal ["dave@example.org"], mail.to
      assert_equal ["depot@example.com"], mail.from
      assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "shipped" do
    let(:mail) { OrderNotifier.shipped }

    it "renders the headers" do
      assert_equal "Pragmatic Store Order Shipped", mail.subject
      assert_equal ["dave@example.org"], mail.to
      assert_equal ["depot@example.com"], mail.from
      assert_match /<td>1&times;<\/td>\s*<td>Programming Ruby 1.9<\/td>/, ➤
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
