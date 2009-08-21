from jade.common.forms import DynamicForm
from jade.orders.models import *

class SaleForm(DynamicForm):
	def __init__(self, lang, *args, **kwargs):
		super(SaleForm, self).__init__(*args, **kwargs)
		self.make_fields_dynamic(lang, ('notes',))

	class Meta:
		model = Sale
		
class PurchaseForm(DynamicForm):
	def __init__(self, lang, *args, **kwargs):
		super(PurchaseForm, self).__init__(*args, **kwargs)
		self.make_fields_dynamic(lang, ('notes',))

	class Meta:
		model = Purchase
