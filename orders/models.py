from django.db.models import *
from jade.entities.models import Client, Site, Vendor
#from jade.accounting.models import *
from jade.inventory.models import Warranty, ProductBase
from django.utils.translation import ugettext_lazy as _
from datetime import datetime

class Order(Model):
	created_at = DateTimeField(default=datetime.now(), null=True, blank=True)
	received = DateTimeField(null=True, blank=True)
	created_by = DateTimeField(null=True, blank=True)
	receipt_filename = CharField(max_length=50, default='')
	notes = TextField(null=True, blank=True)
	active = BooleanField(default=True)
	total = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	paid = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	number = CharField(max_length=50, default='')
	
	class Meta:
		verbose_name_plural = _('Orders')
		verbose_name = _('Order')
	def __unicode__(self):
		return 'Order Number:' + str(self.number)
	@permalink
	def get_absolute_url(self):
		return ('orders.show_order', None, { 'object_id': self.id })
	
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

