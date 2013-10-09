require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  test "product price must be positive" do
    message = "must be greater than or equal to 0.01"
    product = products(:mine)
    
    product.price = -1
    assert product.invalid?
    assert_equal message, product.errors[:price].join('; ')
    
    product.price = 0
    assert product.invalid?
    assert_equal message, product.errors[:price].join('; ')
    
    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(:title       => "My Other Book Title",
                :description => "yyy",
                :price       => 1,
                :image_url   => image_url)
  end

  test "image url should have a certain extension" do
    ok = ["fred.gif", "fred.jpg", "fred.png", "FRED.JPG", "FRED.Jpg",
          "http://a.b.c/x/y/z/fred.gif"]
    bad = ["fred.doc",  "fred.gif/more",  "fred.gif.more"]
    
    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end
    
    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test "product is not valid without a unique title" do
    product = Product.new(:title       => products(:mine).title,
                          :description => "xxx", 
                          :price       => 1, 
                          :image_url   => "barney.gif")
    
    assert !product.save
    assert_equal "has already been taken", product.errors[:title].join('; ')
  end
end
