require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
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
#  	assert Account.find(1).balance==4,"Account.find(1).balance==#{Account.find(1).balance}"
  end # def test_balance
end
