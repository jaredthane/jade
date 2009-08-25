from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from jade.orders.models import *
from jade.orders.forms import *
from jade.common.views import *
from django.contrib.auth.decorators import login_required
from django.forms.models import inlineformset_factory

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
	try:
		print "upc=" + str(upc)
		
		p=ProductBase.objects.get(bar_code=upc)
		line=Line(product=p, quantity=1)
		form=LineForm(instance=line)
		return render_to_response('orders/new_line.html', {'form': form})
	except ValueError:
		return "Unable to find a product with that upc"
def new_line(request):
	upc = request.GET.get('upc', '')
	try:
		p=ProductBase.objects.get(upc=upc)
		line=Line(product=p, quantity=1)
		form=LineForm(instance=line)
		return render_to_response('orders/new_line.html', {'form': form})
	except ValueError:
		return "Unable to find a product with that upc"
	
def edit_sale(request, object_id = None):
	LineFormSet = inlineformset_factory(Sale, Line, extra=1, fields=('order','product', 'quantity','price'))
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
			sale_form = SaleForm(request.POST, instance=sale)
			all_ok=sale_form.is_valid()
			if all_ok:
				sale=sale_form.save()
			line_formset = LineFormSet(request.POST, instance=sale)
			all_ok += line_formset.is_valid()
			if all_ok:
				line_formset.save()
			if all_ok==2:
				current_url=reverse('show_sale', kwargs={'object_id':sale.pk} )
				return render_to_response('orders/show_sale.html', {'obj': sale, 'current_url':current_url, 'current_lang':current_lang})
		except:
			print 
	current_url=request.get_full_path()
	return render_to_response('orders/edit_sale.html', {'obj': sale, 'sale_form':sale_form, 'formset':line_formset, 'current_url':current_url, 'current_lang':current_lang})

