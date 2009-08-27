from jade.inventory.models import *
from django.forms import *
from jade.common.forms import DynamicForm
		
class ProductForm(DynamicForm):
	def __init__(self, lang, *args, **kwargs):
		super(ProductForm, self).__init__(*args, **kwargs)
		self.make_fields_dynamic(lang, ('name',))

	class Meta:
		model = Product
