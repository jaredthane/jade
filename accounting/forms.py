from jade.accounting.models import *
from django.forms import ModelForm


class AccountForm(ModelForm):
	class Meta:
		model = Account
		fields = ('name', 'parent','modifier','number')


