from django.db.models import *
from django.utils.translation import ugettext_lazy as _
from jade.entities.models import *
from jade.accounting.models import Account
from transmeta import TransMeta
#from jade.orders.models import *

class UnitOfMeasure(Model):
	__metaclass__ = TransMeta
	name = CharField(max_length=50, default='')
	def __unicode__(self):
		return self.name
	class Meta:
		translate = ('name', )
		verbose_name_plural = _('Units Of Measure')
		verbose_name = _('Unit Of Measure')

class PriceBase(object):
	fixed_price = DecimalField(max_digits=5, decimal_places=2, default="0.00")
	relative_price = DecimalField(max_digits=5, decimal_places=2, default="0.00")

class ProductCategory(Model):
	name = CharField(max_length=50, default='')
	def __unicode__(self):
		return self.name
	class Meta:
		verbose_name_plural = _('Categories')
		verbose_name = _('Category')
		
class ProductBase(Model):
	__metaclass__ = TransMeta
	name = CharField(max_length=50, default='')
	description = TextField(default='', blank=True)
	bar_code = CharField(max_length=50, default='')
	unit = ForeignKey(UnitOfMeasure)
	revenue_account = ForeignKey(Account, null=True, blank=True)
	categories = ManyToManyField(ProductCategory, blank=True)
	tax = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	class Meta:
		translate = ('name', 'description')
	def __unicode__(self):
		return self.name
	def get_absolute_url(self):
		return u'/inventory/product/%s' % self.id
	
class Product(ProductBase):
	vendor = ForeignKey(Vendor)
	location = CharField(max_length=50, default='', blank=True)
	model = CharField(max_length=50, default='', blank=True)
	def save(self, *args, **kwargs):
		super(Product, self).save()
		for site in Site.objects.all():
			Inventory.objects.create(product=self, site=site)
		for price_group in PriceGroup.objects.all():
			Price.objects.create(product=self, price_group=price_group)
	class Meta:
		verbose_name_plural = _('Products')
		verbose_name = _('Product')
	def get_absolute_url(self):
		return u'/inventory/product/%s' % self.id

	
class SerialNumber(Model):
	number = CharField(max_length=50, default='')
	product = ForeignKey(Product)
	def __unicode__(self):
		return self.name
	class Meta:
		verbose_name_plural = _('Serial Numbers')
		verbose_name = _('Serial Number')
		unique_together = ("product", "number")

		
class Service(ProductBase):
	start = DateTimeField()
	end = DateTimeField()
	def get_absolute_url(self):
		return u'/inventory/service/%s' % self.id
	class Meta:
		verbose_name_plural = _('Services')
		verbose_name = _('Service')

class WarrantyPolicy(Model):
	price = DecimalField(max_digits=5, decimal_places=2, default="0.00")
	months = IntegerField()
	product = ForeignKey(ProductBase)
	
class Warranty(Model):
	started = DateTimeField()
	price = DecimalField(max_digits=5, decimal_places=2, default="0.00")
	months = IntegerField()
	product = ForeignKey(ProductBase)
	notes = TextField()
	class Meta:
		verbose_name_plural = _('Warranties')
		verbose_name = _('Warranty')

class Inventory(Model):
	product = ForeignKey(Product)
	site = ForeignKey(Site)
	minimum = IntegerField(blank=True, default=0)
	maximum = IntegerField(blank=True, default=0)
	qty_to_order = IntegerField(blank=True, default=0)
	quantity = IntegerField(blank=True, default=0)
	default_sales_warranty = ForeignKey(WarrantyPolicy, related_name='sales_warranty_id', blank=True,null=True)
	default_purchase_warranty = ForeignKey(WarrantyPolicy, related_name='purchase_warranty_id', blank=True,null=True)
	cost = DecimalField(max_digits=5, decimal_places=2, blank=True, default="0.00")
	default_cost = DecimalField(max_digits=5, decimal_places=2, blank=True, default="0.00")
		
class PriceGroupName(Model):
	name = CharField(max_length=50, default='')
	class Meta:
		verbose_name_plural = _('Price Groups')
		verbose_name = _('Price Group')
	## Need to add price_groups for each site, right?
	
class PriceGroup(Model):
	price_group_name = ForeignKey(PriceGroupName)
	site = ForeignKey(Site)
	def save(self, *args, **kwargs):
		super(PriceGroup, self).save()
		for product in Product.objects.all():
			Price.objects.create(product=product, price_group=self)

class Price(Model, PriceBase):
	product = ForeignKey(ProductBase)
	price_group = ForeignKey(PriceGroup)
	available = BooleanField()
	class Meta:
		verbose_name_plural = _('Prices')
		verbose_name = _('Price')

