from jade.accounting.models import *
from django.forms import *

class AccountForm(ModelForm):
	class Meta:
		model = Account
		
#class AccountForm(Form)
#	name = forms.CharField()
#	parent = forms.ModelChoiceField(Account.objects.all())
#	account_type=ChoiceField(choices=Account.MODIFIER_CHOICES)
#	number = forms.CharField()

