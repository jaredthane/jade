require 'test_helper'

class SerialTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "my test" do
  	s= Serial.create(:product_id=>'111', :number=>'AAAAA')
  	assert_equal( s.id, "AAAAA~111", "s.id is #{s.id} and s.errors is #{s.errors.inspect}" )
    assert s==Serial.find("AAAAA~111")
    assert s.number=='AAAAA'
    assert s.product_id=="111"
    assert_instance_of(Product,s.product)
  end
end
