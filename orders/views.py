from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from jade.orders.models import *
from jade.orders.forms import *
from django.contrib.auth.decorators import login_required

def index_sales(request):
	order_list = Sale.objects.all()
	current_url=request.get_full_path()
	current_lang=request.session['django_language']
	return render_to_response('orders/index_purchases.html', {'order_type':'Sale', 'order_list': order_list, 'current_url':current_url, 'current_lang':current_lang})

def index_purchases(request):
	order_list = Purchase.objects.all()
	current_url=request.get_full_path()
	current_lang=request.session['django_language']
	return render_to_response('orders/index_sales.html', {'order_type':'Purchase', 'order_list': order_list, 'current_url':current_url, 'current_lang':current_lang})
		
def show_sale(request):
	pass
def show_purchase(request):
	pass
def edit_sale(request):
	pass
def edit_purchase(request, order_id = None):
	current_lang=request.session['django_language']
	if request.method == 'POST': #POST
		print "POSTING"
		print "request.POST=" + str(request.POST)
		if order_id: #UPDATE
			print "UPDATEING"
			o = get_object_or_404(Purchase, pk=account_id)
			form = PurchaseForm(current_lang, request.POST, instance=a)
		else: #CREATE
			print "CREATE"
			form = PurchaseForm(current_lang, request.POST)
		try:
			print "here1"
			o=None
			o=form.save()
			print "here2"
			current_url=reverse('show_purchase', kwargs={'order_id':o.pk} )
			return render_to_response('orders/show_purchase.html', {'order': o, 'current_url':current_url, 'current_lang':current_lang})
		except ValueError:
			print "here3"
			current_url=request.get_full_path()
			return render_to_response('orders/edit_purchase.html', {'order': (o or None), 'form':form, 'current_url':current_url, 'current_lang':current_lang})
	else: # GET
		print "GETTING"
		current_url=request.get_full_path()
		if order_id: #EDIT
			print "EDITING"
			o = get_object_or_404(Purchase, pk=order_id)
			form = PurchaseForm(current_lang, instance=o)
		else: #NEW
			print "NEW"
			o=None
			form=PurchaseForm(current_lang)
	return render_to_response('orders/edit_purchase.html', {'order': o, 'form':form, 'current_url':current_url, 'current_lang':current_lang})


