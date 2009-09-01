from jade.common.forms import DynamicForm
from jade.orders.models import *
from django.forms import *
from django.forms.formsets import formset_factory
from jade.orders.widgets import StaticText
from django.forms.models import inlineformset_factory

class SaleForm(ModelForm):
	class Meta:
		model = Sale
		fields = ('client','site','number','created_at')
		
class PurchaseForm(DynamicForm):
	class Meta:
		model = Purchase

#class ProductField(ModelChoiceField):
#	def __init__(self, **kw):
#		ModelChoiceField.__init__(self, **kw)
		
class SimpleLineForm(ModelForm):
#	notes = CharField(widget=HiddenInput(),required=False)
#	warranty = ModelChoiceField(Warranty, widget=HiddenInput(),required=False)
#	received = DateTimeField(widget=HiddenInput(),required=False)
#	tax = DecimalField(widget=HiddenInput(),required=False)
	product = ModelChoiceField(ProductBase.objects, empty_label=None,required=False)


#	DELETE = BooleanField(widget=HiddenInput(),required=False)
	class Meta:
		model = Line
		exclude=('serial_numbers')
		
SimpleLineFormSet = inlineformset_factory(Sale, Line, extra=0, form=SimpleLineForm)
#class LineFormSet(SimpleLineFormSet):
#	def add_blank_form(self):
#		self.extra+=1
#		self._construct_form(self.total_form_count())
#		return self.forms[-1]
		
class DetailedLineForm(ModelForm):
	order = ModelChoiceField(queryset=Order.objects.all(), widget=HiddenInput())
#	def __init__(self, lang, *args, **kwargs):
#		super(LineForm, self).__init__(*args, **kwargs)
#		self.make_fields_dynamic(lang, ('notes',))
	class Meta:
		model = Line
		fields=('order','product', 'quantity','price')
#LineFormSet = formset_factory(LineForm)
