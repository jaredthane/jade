from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from jade.orders.models import *
from jade.orders.forms import *
from jade.common.views import *
from django.contrib.auth.decorators import login_required
from django.forms.models import inlineformset_factory
from django.core.paginator import Paginator

import sys

def index_sales(request):
	object_list =	Sale.objects.all()
	p = Paginator(object_list, 2)
	
	return generic_index(request, Sale, p)
	
def index_purchases(request):
	order_list = Purchase.objects.all()	
	return generic_index(request, Purchase, object_list)	

def show_serials(request, object_id):
	obj = get_object_or_404(Line, pk=object_id)
	current_url=request.get_full_path()
	current_lang=request.session['django_language']
	return render_to_response('orders/show_serials.html', {'obj': obj, 'current_url':current_url, 'current_lang':current_lang})
	
def show_sale(request, object_id):
	return generic_show(request, object_id, Sale)
	
def show_purchase(request, object_id):
	return generic_show(request, object_id, Purchase)

def edit_purchase(request, object_id = None):
	return generic_edit(request, Purchase, PurchaseForm, object_id)
	
def edit_serial(request, object_id = None):
	num = int(request.POST.get('num', '0'))
	form = SerialFormSet()._construct_form(num)
	return render_to_response('orders/edit_serial.html', {'form': form})
	
def edit_line(request, object_id = None):
	upc = request.POST.get('upc', '')
	num = int(request.POST.get('num', '0'))
	try:
		print "upc=" + str(upc)
		print "num=" + str(num)
		
		p=ProductBase.objects.get(bar_code=upc)
		tax=p.tax
#		LineFormSet = inlineformset_factory(Sale, Line, extra=num+1, form=SimpleLineForm)
#		formset=LineFormSet(initial=[{'product':p},])
		form=LineFormSet()._construct_form(num)
		form.instance.product=p
		form.product_name=p.name
		form.fields['product'].initial=p.pk
		return render_to_response('orders/edit_line.html', {'form': form})
	except ValueError:
		return "Unable to find a product with that upc"
	
def edit_sale(request, object_id = None):
	current_lang=request.session['django_language']
	if request.method == 'GET': #GET
		current_url=request.get_full_path()
		if object_id: #EDIT
			sale = get_object_or_404(Sale, pk=object_id)
		else: #NEW
			sale=Sale()
		form = SaleForm(instance=sale)
	else: #POST
		print "object_id=" + str(object_id)
		if object_id: #UPDATE
			sale = get_object_or_404(Sale, pk=object_id)
			print "get_object_or_404(Sale, pk=object_id)=" + str(get_object_or_404(Sale, pk=object_id))
			current_url=reverse('show_'+Sale._meta.verbose_name.lower(), kwargs={'object_id':sale.pk} )
			print "sale=" + str(sale)
		else: #CREATE
			sale=None
		try:
			print "request.POST"+str(request.POST)
			form = SaleForm(request.POST, instance=sale)
			if form.is_valid():
				form.save()
				print "sale=" + str(sale)
				current_url=reverse('show_sale', kwargs={'object_id':sale.pk} )
				return render_to_response('orders/show_sale.html', {'obj': sale, 'current_url':current_url, 'current_lang':current_lang})
		except ValueError:
			print "Unexpected error:", sys.exc_info()[0]
			print "Unexpected error details:", sys.exc_info()[0].__dict__
#			for field in form.fields:
#				print "field.__dict__=" + str(field.__dict__)
			if form:
				print "form.__dict__=" + str(form.__dict__)
	current_url=request.get_full_path()
	for lform in form.lines_formset.forms:
		print "prefix="+lform.prefix
	return render_to_response('orders/edit_sale.html', {'obj': sale, 'form':form, 'current_url':current_url, 'current_lang':current_lang})

