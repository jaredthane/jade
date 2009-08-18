from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.http import HttpResponseRedirect
from django.core.urlresolvers import reverse
from jade.accounting.models import *
from jade.accounting.forms import *

def index(request):
	account_list = Account.objects.all()
#	headers = [	[_('Name'),20], [_('Vendor'),20], [_('Min'),5], [_('Max'),5], [_('Quantity'),10], [_('Price'),10], [_('Cost'),10],  [_('Bar Code'),None]]
	headers = [[_('Number'),20], [_('Name'),20], [_('Branch'),20], [_('Type'),20],[_('Balance'),None]]
	return render_to_response('accounting/index_accounts.html', {'account_list': account_list, 'headers':headers})
def show(request, account_id):
	a = get_object_or_404(Account, pk=account_id)
	return render_to_response('accounting/show_account.html', {'account': a})
	
def edit(request, account_id=None):
	if request.method == 'POST': #POST
		print "POSTING"
		if account_id: #UPDATE
			print "UPDATEING"
			a = get_object_or_404(Account, pk=account_id)
			form = AccountForm(request.POST, instance=a)
		else: #CREATE
			print "CREATE"
			form = AccountForm(request.POST)
		try:
			a=form.save()
			return render_to_response('accounting/show_account.html', {'account': a})
		except:
			return render_to_response('accounting/edit_account.html', {'form':form})
	else: # GET
		print "GETTING"
		if account_id: #EDIT
			print "EDITING"
			a = get_object_or_404(Account, pk=account_id)
			form = AccountForm(instance=a)
		else: #NEW
			print "NEW"
			a=None
			form=AccountForm()
	return render_to_response('accounting/edit_account.html', {'account': a, 'form':form})


