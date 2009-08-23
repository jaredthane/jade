from jade.common.forms import DynamicForm
from jade.orders.models import *
from django.forms import *

class SaleForm(ModelForm):
#	def __init__(self, lang, *args, **kwargs):
#		super(SaleForm, self).__init__(*args, **kwargs)
##		self.make_fields_dynamic(lang, ('notes',))

	class Meta:
		model = Sale
		exclude = ('notes',)
		
class PurchaseForm(DynamicForm):
	def __init__(self, lang, *args, **kwargs):
		super(PurchaseForm, self).__init__(*args, **kwargs)
		self.make_fields_dynamic(lang, ('notes',))

	class Meta:
		model = Purchase
		
class LineForm(ModelForm):
	order = ModelChoiceField(queryset=Order.objects.all(), widget=HiddenInput())
#	def __init__(self, lang, *args, **kwargs):
#		super(LineForm, self).__init__(*args, **kwargs)
#		self.make_fields_dynamic(lang, ('notes',))
	class Meta:
		model = Line
		exclude = ('notes','order')

