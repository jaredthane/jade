require 'test_helper'

class CostTest < ActiveSupport::TestCase
  test "consume" do
    p=Product.create(:name='cat', :upc='1231344')
    s=Entity.create(:name='home', :entity_type_id=>Entity::SITE)
    o=Order.create()
    Cost.create(:product=>p, :entity_id=>s, :order=>o, :value=>0.25, :quantity=>2)
    o=Order.create()
    Cost.create(:product=>p, :entity_id=>s, :order=>o, :value=>0.5, :quantity=>3)
    assert_equal .25, first(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}").value
    Cost.consume(p, 1, s)
    assert_equal .25, first(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}").value
    Cost.consume(p, 2, s)
    assert_equal .5, first(:conditions=>"product_id=#{product.id} AND entity_id=#{site.id}").value
  end
end
