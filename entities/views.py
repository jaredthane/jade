from jade.entities.models import *
from jade.entities.forms import *
from jade.common.views import *
from django.contrib.auth.decorators import login_required

@login_required
def index_sites(request):
	return generic_index(request, Site, 'site', 'entities')
@login_required
def show_site(request, object_id):
	return generic_show(request, object_id, Site, 'site', 'entities')
@login_required
def edit_site(request, object_id=None):
	return generic_edit(request, Site, SiteForm, 'site', 'entities', object_id)


def index_clients(request):
	pass
def show_client(request, object_id):
	pass
def edit_client(request, object_id=None):
	pass
	
def index_vendors(request):
	pass
def show_vendor(request, object_id):
	pass
def edit_vendor(request, object_id=None):
	pass
