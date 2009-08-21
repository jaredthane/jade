#from django.shortcuts import get_object_or_404, render_to_response
#from django.utils.translation import ugettext_lazy as _
#from django.core.urlresolvers import reverse
from jade.accounting.models import Account
from jade.accounting.forms import AccountForm
from jade.common.views import *
from django.contrib.auth.decorators import login_required

@login_required
def index(request):
	return generic_index(request, Account, 'account', 'accounting')
		
@login_required
def show(request, object_id):
	return generic_show(request, object_id, Account, 'account', 'accounting')
	
@login_required
def edit(request, object_id=None):
	return generic_edit(request, Account, AccountForm, 'account', 'accounting', object_id)

