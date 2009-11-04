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
def edit_serial(request, object_id = None):
	num = int(request.POST.get('num', '0'))
	serial_form = SerialOnLineFormSet()._construct_form(num)
	return render_to_response('orders/edit_serial.html', {'serial_form': serial_form})
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
		form=SimpleLineFormSet()._construct_form(num)
		form.instance.product=p
		form.product_name=p.name
		form.fields['product'].initial=p.pk
		return render_to_response('orders/edit_line.html', {'form': form})
	except ValueError:
		return "Unable to find a product with that upc"
	
def edit_sale(request, object_id = None):
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
		line_formset = SimpleLineFormSet(instance=sale)
#		serial_formsets=[]
		for form in line_formset.forms:
			form.serial_formset=SerialOnLineFormSet(instance=form.instance, prefix=form.prefix+"-serial_set")
#		for line in sale.line_set.all():
#			serial_formsets.append()
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
			print "sale_form.errors=" + str(sale_form.errors)
			print "checkpoint1"
			print "allok:"+str(all_ok)
			all_ok = all_ok and sale_form.is_valid()
			print "checkpoint2"
			if all_ok:
				sale=sale_form.save()
			print "allok:"+str(all_ok)
			print "checkpoint3"
			line_formset = SimpleLineFormSet(request.POST, instance=sale)
			for form in line_formset.forms:
					print "form.errors=" + str(form.errors)
					form.serial_formset=SerialOnLineFormSet(instance=form.instance, prefix=form.prefix+"-serial_set")
					for form in form.serial_formset.forms:
						print "form.errors=" + str(form.errors)
#			for form in line_formset.forms:
#				if form.product:
#					form.product_name=form.product.name
#				else:
#					del(line_formset.forms, form)
#				print "form.__dict__=" + str(form.__dict__)
			print "checkpoint4a"
			print "allok:"+str(all_ok)
			all_ok = all_ok and line_formset.is_valid()
			print "checkpoint4b"
			print "allok:"+str(all_ok)
			for form in line_formset.forms:
				all_ok = all_ok and form.serial_formset.is_valid()
				for sform in form.serial_formset.forms:
					print sform.data
					print "sform.errors!!=" + unicode(sform.errors)
			print "checkpoint4c"
			print "allok:"+str(all_ok)
			#======== Testing Code ==============
			for form in line_formset.forms:
				print "form.errors=" + str(form.errors)
				for sform in form.serial_formset.forms:
					print "form.errors=" + str(sform.errors)
			#======== End of Testing Code ==============
			print "checkpoint5a"
			print "allok:"+str(all_ok)
			if all_ok:
				line_formset.save()
				for form in line_formset.forms:
					form.serial_formset.save()
				print "checkpoint5b"
				
			print "checkpoint6"
			print "allok:"+str(all_ok)
			if all_ok:
				print "checkpoint7a"
				current_url=reverse('show_sale', kwargs={'object_id':sale.pk} )
				print "checkpoint7b"
				for form in line_formset.forms:
					if form.cleaned_data:
						print "form.cleaned_data=" + str(form.cleaned_data)
					if form.instance:
						print "###form.instance=" + str(form.instance)
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

