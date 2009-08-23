from jade.common.forms import DynamicForm
from jade.entities.models import *
from django.utils.translation import ugettext_lazy as _
from settings import *

class ContactForm(DynamicForm):
	## For handling clients and vendors
	def __init__(self, lang, *args, **kwargs):
		super(ContactForm, self).__init__(*args, **kwargs)
		self.make_fields_dynamic(lang, ('notes',))

	class Meta:
		model = Contact

class SiteForm(DynamicForm):
	def __init__(self, lang, *args, **kwargs):
		super(SiteForm, self).__init__(*args, **kwargs)
		self.make_fields_dynamic(lang, ('notes',))
		
#	LANGUAGE_CODE = 'es'
#	CASH_ACCOUNT_DEFAULT_NAME = ' Cash'
#INVENTORY_ACCOUNT_DEFAULT_NAME = ' Inventory'
#EXPENSE_ACCOUNT_DEFAULT_NAME = ' Expense'
#RETURNS_ACCOUNT_DEFAULT_NAME = ' Returns'
#TAX_ACCOUNT_DEFAULT_NAME = ' Tax'
#PAYABLES_ACCOUNT_DEFAULT_NAME = ' Payables'
	def clean_inventory_account(self):
		return self.cleaned_data['inventory_account'] or Account.objects.create(name=_('inventory'), modifier=1)
	def clean_cash_account(self):
		return self.cleaned_data['cash_account'] or Account.objects.create(name=_('Cash'), modifier=1)
	def clean_expense_account(self):
		return self.cleaned_data['expense_account'] or Account.objects.create(name=_('expense'), modifier=1)
	def clean_returns_account(self):
		return self.cleaned_data['returns_account'] or Account.objects.create(name=_('returns'), modifier=1)
	def clean_tax_account(self):
		return self.cleaned_data['tax_account'] or Account.objects.create(name=_('tax'), modifier=1)
	def clean_payables_account(self):
		return self.cleaned_data['payables_account'] or Account.objects.create(name=_('payables'), modifier=1)

	class Meta:
		model = Site
