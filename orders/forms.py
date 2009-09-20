from jade.common.forms import DynamicForm
from jade.orders.models import *
from django.forms import *
from django.forms.formsets import formset_factory
from jade.orders.widgets import StaticText
from django.forms.models import inlineformset_factory
from jade.common.widgets import *
#class SaleForm(ModelForm):
#	site = ModelChoiceField(Site.objects, widget=SelectWithPop)
#	client = ModelChoiceField(Client.objects, widget=SelectWithPop)
#	class Meta:
#		model = Sale
#		fields = ('client','site','number','created_at')

class SaleForm(ModelForm):
	site = ModelChoiceField(Site.objects, widget=SelectWithPop)
	client = ModelChoiceField(Client.objects, widget=SelectWithPop)
	class Meta:
		model = Sale
		fields = ('client','site','number','created_at')
	def __init__(self, *args, **kwargs):
		super(SaleForm, self).__init__(*args, **kwargs)
		self.line_formset = SimpleLineFormSet(instance=self.instance, data=self.data, prefix = form.prefix + "-line_set")
	def save(self, commit=True):
		ok = True
		ok = super(SaleForm, self).save(commit)
		for line in self.forms:
			ok = ok and line.save()
		return ok
	def is_valid(self):
		ok = True
		ok = super(SaleForm, self).is_valid()
		for line in self.forms:
			ok = ok and line.is_valid()
		return ok
		
		
		
class PurchaseForm(DynamicForm):
	class Meta:
		model = Purchase
		
class SerialOnLineForm(ModelForm):
	class Meta:
		model = SerialOnLine
		
class SimpleLineForm(ModelForm):
#	notes = CharField(widget=HiddenInput(),required=False)
#	warranty = ModelChoiceField(Warranty, widget=HiddenInput(),required=False)
#	received = DateTimeField(widget=HiddenInput(),required=False)
#	tax = DecimalField(widget=HiddenInput(),required=False)
	warranty = ModelChoiceField(WarrantyPolicy.objects, widget=SelectWithPop, required=False)
	product = ModelChoiceField(ProductBase.objects, empty_label=None, required=False)
#	product_name = CharField(widget=HiddenInput(),required=False)
#	DELETE = BooleanField(widget=HiddenInput(),required=False)
	def __init__(self, *args, **kwargs):
		super(SimpleLineForm, self).__init__(*args, **kwargs)
		self.serial_formset = SerialOnLineFormSet(instance=self.instance, data=self.data)
	
	class Meta:
		model = Line
		exclude=('serial_numbers')
		
SimpleLineFormSet =  inlineformset_factory(Sale, Line, extra=0, form=SimpleLineForm)
SerialOnLineFormSet = inlineformset_factory(Line, SerialOnLine, extra=0, form=SerialOnLineForm)
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
