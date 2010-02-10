require 'test_helper'

class EntityTest < ActiveSupport::TestCase
  test "creating a new balance(should set created_at and balance)" do
  	fred = Account.create(:name=>'Fred', :modifier=>-1)
		tom = Account.create(:name=>'Tom', :modifier=>1)
    contract = Contract.create_simple_accounting_transaction(:from=>fred, :to=>tom, :value=>7, :comments=>'simple value transfer')
    contract2 = Contract.create_simple_accounting_transaction(:from=>fred, :to=>tom, :value=>4, :comments=>'another simple value transfer')
    assert_equal 7, contract.entries[0].balance
    assert_equal 7, contract.entries[1].balance
    assert_equal 11, contract2.entries[0].balance
    assert_equal 11, contract2.entries[1].balance
    assert_equal 11, fred.balance
    assert_equal 11, tom.balance
  end
end
