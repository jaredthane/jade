require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "find_by_name_or_create" do
  	a1=Account.find_by_name_or_create({:name=>"Efectivo", :number=>'9999'})
  	a2=Account.find_by_name_or_create({:name=>"Zoomer", :number=>'9999'})
    assert a1.number=='1000', "a1=#{a1.inspect}"
    assert a2.number=="9999", "a2=#{a2.inspect}"
    assert Account.all.length==41, "Account.all.length=#{Account.all.length}"
  end
  test "search" do
    assert Account.search('Ef').length==2, "Account.search('Ef').length=#{Account.search('Ef').length}"
    assert Account.search('','child').length==38, "Account.search('','child').length=#{Account.search('','child').length}"
    assert Account.search('','parent').length==2, "Account.search('','parent').length=#{Account.search('','parent').length}"
    assert Account.search('Ef','child').length==1, "Account.search('Ef','child').length=#{Account.search('','child').length}"
  end
  test "children and all_children" do
  	assert Account.find_by_number('2001').children.length==35, "Account.find_by_number('2001').children.length=#{Account.find_by_number('2001').children.length}"
    assert Account.find_by_number('2001').all_children.length==36, "Account.find_by_number('2001').all_children.length=#{Account.find_by_number('2001').all_children.length}"
  end
  test "balance" do
  	fred = Account.create(:name=>'Fred', :modifier=>-1)
		tom = Account.create(:name=>'Tom', :modifier=>1)
    contract = Contract.create_simple_accounting_transaction(:from=>fred, :to=>tom, :value=>7, :comments=>'simple value transfer')
    contract2 = Contract.create_simple_accounting_transaction(:from=>fred, :to=>tom, :value=>4, :comments=>'another simple value transfer')
		assert_equal -1, fred.modifier
		assert_equal 1, tom.modifier
  	assert_equal 11, fred.balance
  	assert_equal 11, tom.balance
  end # def test_balance
  test "validate" do
  	dup=Account.create(:name=>'dup')
  	dupdup=Account.create(:name=>'dup')
  	assert_equal 1, dupdup.errors.length
  end
  test "transfer_balance_to" do
  	fred = Account.create(:name=>'Fred', :modifier=>1)
		tom = Account.create(:name=>'Tom', :modifier=>-1)
		Entry.create(:account=>fred, :value=>7, :multiplier=>1)
  	assert_equal 7, fred.balance
  	assert_equal 0, tom.balance
		fred.transfer_balance_to(tom)
  	assert_equal 0, fred.balance
  	assert_equal -7, tom.balance
  end
  test	"do checks" do
  	fred = Account.create(:name=>'Fred', :modifier=>-1)
		tom = Account.create(:name=>'Tom', :modifier=>1)
    contract = Contract.create_simple_accounting_transaction(:from=>fred, :to=>tom, :value=>7, :comments=>'simple value transfer')
    assert_equal 0, Account.check
    Entry.create(:account=>fred, :value=>7, :multiplier=>1)
    assert_equal 7, Account.check
  end
end
