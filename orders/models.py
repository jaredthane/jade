from django.db.models import *
from jade.entities.models import Client, Site, Vendor
#from jade.accounting.models import *
from jade.inventory.models import Warranty, ProductBase
from multilingual import Translation

class Order(Model):
	created_at = DateTimeField()
	received = DateTimeField()
	created_by = DateTimeField()
	receipt_filename = CharField(max_length=50, default='')
	class Translation(Translation):
		notes = TextField(null=True, blank=True)
	active = BooleanField(default=True)
	total = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	paid = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	
class Sale(Order):
	client = ForeignKey(Client)
	site = ForeignKey(Site)

class Purchase(Order):
	site = ForeignKey(Site)
	vendor = ForeignKey(Vendor)
	
class Line(Model):
	order = ForeignKey(Order)
	quantity = IntegerField()
	price = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	notes = TextField()
	received = DateTimeField()
	warranty = OneToOneField(Warranty, blank=True, null=True)

class NonInventoryLine(Line):
	description = TextField()
	
class InventoryLine(Line):
	product = ForeignKey(ProductBase)

