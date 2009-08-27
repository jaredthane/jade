from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from jade.orders.models import *
from jade.orders.forms import *
from jade.common.views import *
from django.contrib.auth.decorators import login_required
from django.forms.models import inlineformset_factory
import sys

def index_sales(request):
	object_list =	Sale.objects.all()
	return generic_index(request, Sale, object_list)
	
def index_purchases(request):
	order_list = Purchase.objects.all()	
	return generic_index(request, Purchase, object_list)	
	
def show_sale(request, object_id):
	return generic_show(request, object_id, Sale)
	
def show_purchase(request, object_id):
	return generic_show(request, object_id, Purchase)
#def edit_sale(request, object_id = None):
#	if request.method == "POST":
#		  oform = SaleForm(request.POST, instance=Sale())
#		  lforms = [LineForm(request.POST, prefix=str(x), instance=Line()) for x in range(0,3)]
#		  if oform.is_valid() and all([lf.is_valid() for lf in lforms]):
#		      new_sale = oform.save()
#		      for lf in lforms:
#		          new_line = lf.save(commit=False)
#		          new_line.order = new_order
#		          new_line.save()
#		      return HttpResponseRedirect('/sales/new/')
#	else:
#		  oform = SaleForm(instance=Sale())
#		  lforms = [LineForm(prefix=str(x), instance=Line()) for x in range(0,3)]
#	return render_to_response('orders/edit_sale.html', {'sale_form': oform, 'line_forms': lforms})
def edit_purchase(request, object_id = None):
	return generic_edit(request, Purchase, PurchaseForm, object_id)
def edit_line(request, object_id = None):
	upc = request.POST.get('upc', '')
	num = int(request.POST.get('num', '0'))
	try:
		print "upc=" + str(upc)
		print "num=" + str(num)
		
		p=ProductBase.objects.get(bar_code=upc)
#		LineFormSet = inlineformset_factory(Sale, Line, extra=num+1, form=SimpleLineForm)
#		formset=LineFormSet(initial=[{'product':p},])
		form=SimpleLineFormSet()._construct_form(num)
		form.instance.product=p
#		form.fields['product'].initial=p.pk
		return render_to_response('orders/edit_line.html', {'form': form})
	except ValueError:
		return "Unable to find a product with that upc"
	
def edit_sale(request, object_id = None):
	LineFormSet = inlineformset_factory(Sale, Line, extra=0, form=SimpleLineForm)
	current_lang=request.session['django_language']
	if request.method == 'GET': #GET
		print "GETTING"
		current_url=request.get_full_path()
		if object_id: #EDIT
			print "EDITING"
			sale = get_object_or_404(Sale, pk=object_id)
		else: #NEW
			print "NEW"
			sale=Sale()
		sale_form = SaleForm(instance=sale)
		line_formset = LineFormSet(instance=sale)
#		print "line_formset.forms[0].fields['product'].initial=" + str(line_formset.forms[0].fields['product'].initial)
	else: #POST
		print "POSTING"
		if object_id: #UPDATE
			print "UPDATEING"
			sale = get_object_or_404(Sale, pk=object_id)
			print "sale=" + str(sale)
			current_url=reverse('show_'+Sale._meta.verbose_name.lower(), kwargs={'object_id':sale.pk} )
		else: #CREATE
			sale=None
			print "CREATE"
		line_formset=None
		all_ok=True
		try:
			print "request.POST"+str(request.POST)
			sale_form = SaleForm(request.POST, instance=sale)
			print "checkpoint1"
			all_ok=sale_form.is_valid()
			print "checkpoint2"
			if all_ok:
				sale=sale_form.save()
			print "checkpoint3"
			line_formset = LineFormSet(request.POST, instance=sale)
			for form in line_formset.forms:
				print "form.__dict__=" + str(form.__dict__)
			print "checkpoint4"
			all_ok += line_formset.is_valid()
			print "checkpoint5"
			if all_ok:
				line_formset.save()
			print "checkpoint6"
			if all_ok==2:
				print "checkpoint7a"
				current_url=reverse('show_sale', kwargs={'object_id':sale.pk} )
				print "checkpoint7b"
				for form in line_formset.forms:
					print "form.cleaned_data=" + str(form.cleaned_data)
				return render_to_response('orders/show_sale.html', {'obj': sale, 'current_url':current_url, 'current_lang':current_lang})
		except ValueError:
			print "Unexpected error:", sys.exc_info()[0]
			print "Unexpected error details:", sys.exc_info()[0].__dict__
#			for field in form.fields:
#				print "field.__dict__=" + str(field.__dict__)
			if sale_form:
				print "sale_form.__dict__=" + str(sale_form.__dict__)
			if line_formset:
				print "line_formset.__dict__=" + str(line_formset.__dict__)
				print "$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$"
				for x in xrange(len(line_formset._errors)):
					print "----------------------form #%s--------------------------------" % x
					print "line_formset._errors[x]=" + str(line_formset._errors[x])
	current_url=request.get_full_path()
	return render_to_response('orders/edit_sale.html', {'obj': sale, 'sale_form':sale_form, 'formset':line_formset, 'current_url':current_url, 'current_lang':current_lang})

