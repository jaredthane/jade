from jade.inventory.models import Product
from jade.inventory.forms import ProductForm
from jade.common.views import *
from django.contrib.auth.decorators import login_required

@login_required
def show_product(request, object_id):
	return generic_show(request, object_id, Product)
	
@login_required
def edit_product(request, object_id=None):
	return generic_edit(request, Product, ProductForm, object_id)
	
@login_required
def index_products(request):
	object_list =	Product.objects.all()
	return generic_index(request, Product, object_list)
