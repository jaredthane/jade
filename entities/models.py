from django.db.models import *
from jade.accounting.models import Account
from multilingual import Translation

class State(Model):
	name = CharField(max_length=50, default='')

class Entity(Model):
	name = CharField(max_length=50, default='')
	tax_id = CharField(max_length=50, default='')
	state = ForeignKey(State)
	revenue_account = ForeignKey(Account)
	notes = TextField()
	active = BooleanField()

class ReceiptGroup(Model):
	next_receipt_number = IntegerField()
	max_lines_per_receipt = IntegerField()

class Site(Entity):
	phone_format = CharField(max_length=15, default='')
	inventory_account = ForeignKey(Account, related_name='inventory_account_id')
	cash_account = ForeignKey(Account, related_name='cash_account_id')
	expense_account = ForeignKey(Account, related_name='expense_account_id')
	returns_account = ForeignKey(Account, related_name='returns_account_id')
	tax_account = ForeignKey(Account, related_name='tax_account_id')
	payables_account = ForeignKey(Account, related_name='payables_account_id')
	default_receipt_group = ForeignKey(ReceiptGroup)
	def save(self):
		super(Site, self).save()
		for product in Product.objects.all():
			Inventory.objects.create(product=product, site=self)
		


class Contact(Entity):
	home_phone = CharField(max_length=15, default='')
	office_phone = CharField(max_length=15, default='')
	cell_phone = CharField(max_length=15, default='')
	address = TextField()
	birth = DateField()
	email = CharField(max_length=50, default='')
	site = ForeignKey(Site)
	account = ForeignKey(Account)
		
class Client(Contact):
	pass
	#	sales_rep = ForeignKey(User)


class Vendor(Contact):
	pass


