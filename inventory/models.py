from django.db.models import *
from jade.entities.models import *
from jade.accounting.models import Account
#from jade.orders.models import *

class UnitOfMeasure(Model):
	name = CharField(max_length=50, default='')

class PriceBase(object):
	fixed_price = DecimalField(max_digits=5, decimal_places=2, default="0.00")
	relative_price = DecimalField(max_digits=5, decimal_places=2, default="0.00")

class ProductCategory(Model):
	name = CharField(max_length=50, default='')
	
class ProductBase(Model):
	name = CharField(max_length=50, default='')
	description = TextField()
	bar_code = CharField(max_length=50, default='')
	unit = ForeignKey(UnitOfMeasure)
	revenue_account = ForeignKey(Account)
	categories = ManyToManyField(ProductCategory)
		
class Product(ProductBase):
	vendor = ForeignKey(Vendor)
	location = CharField(max_length=50, default='')
	model = CharField(max_length=50, default='')
	def save(self, *args, **kwargs):
		super(Product, self).save()
		for site in Site.objects.all():
			Inventory.objects.create(product=self, site=site)
		for price_group in PriceGroup.objects.all():
			Price.objects.create(product=self, price_group=price_group)

class Service(ProductBase):
	start = DateTimeField()
	end = DateTimeField()

class WarrantyPolicy(Model):
	price = DecimalField(max_digits=5, decimal_places=2, default="0.00")
	months = IntegerField()
	product = ForeignKey(ProductBase)
	
class Warranty(Model):
	started = DateTimeField()
	price = DecimalField(max_digits=5, decimal_places=2, default="0.00")
	months = IntegerField()
	notes = TextField()

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

