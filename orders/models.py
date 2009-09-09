from django.db.models import *
from jade.entities.models import Client, Site, Vendor
#from jade.accounting.models import *
from jade.inventory.models import WarrantyPolicy, ProductBase, SerialNumber
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
	tax = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	products = ManyToManyField(ProductBase, through='Line')
	
	class Meta:
		verbose_name_plural = _('Orders')
		verbose_name = _('Order')
	def __unicode__(self):
		return 'Order Number:' + str(self.number)

	
class Sale(Order):
	client = ForeignKey(Client)
	site = ForeignKey(Site)
	def get_absolute_url(self):
		return u'/orders/sale/%s' % self.id

class Purchase(Order):
	site = ForeignKey(Site)
	vendor = ForeignKey(Vendor)
	def get_absolute_url(self):
		return u'/orders/purchase/%s' % self.id

#class LineItem(Model):
#	name = CharField(max_length=50, default='')
#	description = TextField(default='', blank=True)
#	is_serialized = BooleanField(default='', blank=False)
#class ProductLineItem(LineItem, Product):
#	pass
#class ServiceLineItem(LineItem, Service):
#	pass
class Line(Model):
	order = ForeignKey(Order)
	product = ForeignKey(ProductBase)
	quantity = IntegerField(default=1)
	price = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	notes = TextField(blank=True, default='')
	serial_numbers = ManyToManyField(SerialNumber, blank=True, through='SerialOnLine')
	received = DateTimeField(blank=True, null=True)
	warranty = OneToOneField(WarrantyPolicy, blank=True, null=True)
	tax = DecimalField(max_digits=5, decimal_places=2, default='0.00', blank=True)
	def save(self, *args, **kwargs):
		super(Line, self).save()
		if not self.tax:
			self.tax=self.price*self.product.tax
			
class SerialOnLine(Model):
	line = ForeignKey(Line)
	serial_number = ForeignKey(SerialNumber)

#	def get_is_received():
#		return bool(self.received)
#	def set_is_received(value):
#		if value:
			

#class NonInventoryLine(Line):
#	description = TextField()
	
#class InventoryLine(Line):
#	product = ForeignKey(ProductBase)

