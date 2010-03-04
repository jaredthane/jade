require File.dirname(__FILE__) + '/../test_helper'

class ProductTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "costs" do
    home = Entity.create(:name=>'home', :entity_type_id=>Entity::SITE)
    assert_not_nil home.id
    dog = Product.create(:name=>'dog', :upc=>'131313')
    assert_not_nil dog.id
    dog.default_cost=4
    Cost.create(:product=>dog, :entity=>home, :quantity=>2, :value=>1.25)
  end
  test "total_value_of_inventory" do
    home = Entity.create(:name=>'home', :entity_type_id=>Entity::SITE)
    assert_not_nil home.id
    dog = Product.create(:name=>'dog', :upc=>'131313')
    assert_not_nil dog.id
    dog.default_cost=4
    Cost.create(:product=>dog, :entity=>home, :quantity=>2, :value=>1.25)
    dog.quantity(home)=2
    assert_equal 2.50, dog.total_value_of_inventory(home)
  
  end
end

