require 'rails_helper'

valid_attributes = { title: 'Lorem Ipsum', description: 'Wibbles are fun!', image_url: 'lorem.jpg', price: 9.00 }

RSpec.describe Product, type: :model do
  it "ensures product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors.any?
  end

  it 'must have a positve product price' do
    product = Product.new(valid_attributes)
    assert product.valid?
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    product.price = -1
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
  end

  it 'only accepts image_url that ends in .gif,.jpg, or.png' do
    def new_product(image_url)
      Product.new(title: "My Book Title", description: "yyy", price: 1, image_url: image_url)
    end

    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} should be valid"
    end
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  it 'is not valid without a unique title' do
    Product.create(valid_attributes)
    product = Product.new(valid_attributes)
    assert product.invalid?
    assert_equal ["has already been taken"], product.errors[:title]
  end
end
