from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from jade.orders.models import *
from jade.orders.forms import *
from jade.common.views import *
from django.contrib.auth.decorators import login_required

from django.forms.formsets import formset_factory

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
def edit_sale(request, object_id = None):
	if request.method == "POST":
		  oform = SaleForm(request.POST, instance=Sale())
		  lforms = [LineForm(request.POST, prefix=str(x), instance=Line()) for x in range(0,3)]
		  if oform.is_valid() and all([lf.is_valid() for lf in lforms]):
		      new_sale = oform.save()
		      for lf in lforms:
		          new_line = lf.save(commit=False)
		          new_line.order = new_order
		          new_line.save()
		      return HttpResponseRedirect('/sales/new/')
	else:
		  oform = SaleForm(instance=Sale())
		  lforms = [LineForm(prefix=str(x), instance=Line()) for x in range(0,3)]
	return render_to_response('orders/edit_sale.html', {'sale_form': oform, 'line_forms': lforms})
def edit_purchase(request, object_id = None):
	return generic_edit(request, Purchase, PurchaseForm, object_id)
def edit_line(request, object_id = None):
	return generic_edit(request, Line, LineForm, object_id)
