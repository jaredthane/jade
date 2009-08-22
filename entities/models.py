from django.db.models import *
from jade.accounting.models import Account
from django.utils.translation import ugettext_lazy as _

class State(Model):
	name = CharField(max_length=50, default='')
	def __unicode__(self):
		return self.name

class Entity(Model):
	name = CharField(max_length=50, default='')
	tax_id = CharField(max_length=50, default='', blank=True)
	state = ForeignKey(State)
	revenue_account = ForeignKey(Account, null=True, blank=True)
	notes = TextField(default='', blank=True)
	active = BooleanField(default=True)
	def __unicode__(self):
		return self.name

class ReceiptGroup(Model):
	name = CharField(max_length=50)
	next_receipt_number = IntegerField()
	max_lines_per_receipt = IntegerField()
	def __unicode__(self):
		return self.name
	class Meta:
		get_latest_by = 'pk'
		ordering = ('name',)		

class Site(Entity):
	phone_format = CharField(max_length=15, default='', blank=True)
	inventory_account = ForeignKey(Account, related_name='inventory_account_id', default=0, blank=True)
	cash_account = ForeignKey(Account, related_name='cash_account_id', null=True, blank=True)
	expense_account = ForeignKey(Account, related_name='expense_account_id', null=True, blank=True)
	returns_account = ForeignKey(Account, related_name='returns_account_id', null=True, blank=True)
	tax_account = ForeignKey(Account, related_name='tax_account_id', null=True, blank=True)
	payables_account = ForeignKey(Account, related_name='payables_account_id', null=True, blank=True)
	default_receipt_group = ForeignKey(ReceiptGroup, default=ReceiptGroup.objects.latest)
	def save(self, *args, **kwargs):
		print "Hello World"
#		if self.inventory_account == -1:
#			self.inventory_account = Account.objects.create(name=self.name + ' Inventory', modifier=1)
#		if not self.cash_account:     #### These account names have to be translated somehow
#			self.cash_account = Account.objects.create(name=self.name + ' '+'Cash', modifier=1)
#		if not self.expense_account:
#			self.expense_account = Account.objects.create(name=self.name + ' '+'Expense', modifier=1)
#		if not self.returns_account:  #### What type of account should this be??
#			self.returns_account = Account.objects.create(name=self.name + ' '+'Returns', modifier=1)
#		if not self.tax_account:
#			self.tax_account = Account.objects.create(name=self.name + ' '+'Tax', modifier=-1)
#		if not self.payables_account:
#			self.payables_account = Account.objects.create(name=self.name + ' '+'Accounts Payable', modifier=-1)
		super(Site, self).save()
		from jade.inventory.models import Product, Inventory
		for product in Product.objects.all():
			Inventory.objects.create(product=product, site=self)
		
class Contact(Entity):
	home_phone = CharField(max_length=15, default='', blank=True)
	office_phone = CharField(max_length=15, default='', blank=True)
	cell_phone = CharField(max_length=15, default='', blank=True)
	address = TextField(default='', blank=True)
	birth = DateField(null=True, blank=True)
	email = CharField(max_length=50, default='', blank=True)
	site = ForeignKey(Site)
	account = ForeignKey(Account, blank=True)
	def save(self):
		account = Account.objects.create(name=self.name, modifier=-1)
		super(Contact, self).save()
		
class Client(Contact):
	pass
	#	sales_rep = ForeignKey(User)


class Vendor(Contact):
	pass


