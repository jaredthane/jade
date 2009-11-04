from jade.common.forms import DynamicForm
from jade.orders.models import *
from django.forms import *
from django.forms.formsets import formset_factory
from jade.orders.widgets import StaticText
from django.forms.models import inlineformset_factory
from jade.common.widgets import *

class SaleForm(ModelForm):
	class Meta:
		model = Sale
		fields = ('client','site','number','created_at')
	def __init__(self, *args, **kwargs):
		super(SaleForm, self).__init__(*args, **kwargs)
		if len(self.data)==0:
			self.lines_formset = LineFormSet(instance=self.instance)
		else:
			self.lines_formset = LineFormSet(instance=self.instance, data=self.data)
	def save(self, commit=True):
		print 'Saving Sale'
		result = super(SaleForm, self).save(commit=commit)
		print 'Saving Lines'
		self.lines_formset.save(commit=commit)
		return result
	def is_valid(self):
		ok = True
		ok = ok and super(SaleForm, self).is_valid()
		ok = ok and self.lines_formset.is_valid()
		print "Sale Valid:" + str(ok)
		return ok

class SimpleLineForm(ModelForm):
	warranty = ModelChoiceField(WarrantyPolicy.objects, widget=SelectWithPop, required=False)
	product = ModelChoiceField(ProductBase.objects, empty_label=None, required=False)
	class Meta:
		model = Line
		exclude=('serial_numbers')
	def __init__(self, *args, **kwargs):
		super(SimpleLineForm, self).__init__(*args, **kwargs)
		if len(self.data)==0:
			self.serials_formset = SerialFormSet(instance=self.instance, prefix=self.prefix+"_serial-set")
		else:
			self.serials_formset = SerialFormSet(instance=self.instance, data=self.data, prefix=self.prefix+"_serial-set")
	def save(self, commit=True):
		print 'Saving Line'
		result = super(SimpleLineForm, self).save(commit=commit)
		print 'Saving Serials'
		self.serials_formset.save(commit=commit)
		return result
	def is_valid(self):
		print "checking if line is valid"
		if not super(SimpleLineForm, self).is_valid(): 
			return False
		if not self.serials_formset.is_valid(): 
			return False
		print "Line Valid."
		return True

#class SimpleLineForm(ModelForm):
#	warranty = ModelChoiceField(WarrantyPolicy.objects, widget=SelectWithPop, required=False)
#	product = ModelChoiceField(ProductBase.objects, empty_label=None, required=False)
#	def __init__(self, *args, **kwargs):
#		super(SimpleLineForm, self).__init__(*args, **kwargs)
##		self.serial_formset = SerialOnLineFormSet(instance=self.instance, data=self.data)
#	
#	class Meta:
#		model = Line
#		exclude=('serial_numbers')
		
class DetailedLineForm(ModelForm):
	order = ModelChoiceField(queryset = Order.objects.all(), widget = HiddenInput())
	class Meta:
		model = Line
		fields=('order','product', 'quantity','price')

class SerialForm(ModelForm):
	def save(self, commit=True):
		print "Saving Serial"
		return super(SerialForm, self).save(commit=commit)
	class Meta:
		model = SerialOnLine
		
LineFormSet =  inlineformset_factory(Sale, Line, extra = 0, form = SimpleLineForm)

		
SerialFormSet = inlineformset_factory(Line, SerialOnLine, extra = 0, form=SerialForm)
		
