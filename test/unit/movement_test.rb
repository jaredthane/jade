require 'test_helper'

class MovementTest < ActiveSupport::TestCase
  test "get a new movement using simple value" do
  	fred = Account.create(:name=>'Fred')
  	tom = Account.create(:name=>'Tom')
  	m = Payment.new_simple_accounting_transaction(:from=>fred, :to=>tom, :value=>3, :comments=>'simple value transfer')
    assert_equal 2, m.entries.length
    assert_equal 3, m.entries[0].value
    assert_equal -1, m.entries[0].multiplier
    assert_equal 3, m.entries[1].value
    assert_equal 1, m.entries[1].multiplier
    assert_equal 'simple value transfer', m.comments
    assert_equal 1, m.direction
    assert_equal "Payment", m.type
  end
  test "create movement using simple value with negative value" do
  	fred = Account.create(:name=>'Fred')
  	tom = Account.create(:name=>'Tom')
  	m = Contract.create_simple_accounting_transaction(:from=>fred, :to=>tom, :value=>-5, :comments=>'simple value transfer')
    assert_equal 2, m.entries.length
    assert_equal 5, m.entries[0].value
    assert_equal 1, m.entries[0].multiplier
    assert_equal 5, m.entries[1].value
    assert_equal -1, m.entries[1].multiplier
    assert_equal 'simple value transfer', m.comments
    assert_equal -1, m.direction
    assert_equal "Contract", m.type
  end
	test "make a new inventory movement using simple quantity" do
  	fred = Entity.create(:name=>'Fred')
  	tom = Entity.create(:name=>'Tom')
  	assert_not_nil fred
  	assert_not_nil tom
  	dog = Product.create(:name=>'Dog')
  	m = Contract.create_simple_inventory_transaction(:from=>fred, :to=>tom, :quantity=>7, :product=>dog, :comments=>'simple value transfer')
  	assert_equal 2, m.entries.length
  	assert_equal 7, m.entries[0].quantity
  	assert_equal -7, m.entries[1].quantity
	end
end
