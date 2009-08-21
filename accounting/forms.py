from jade.accounting.models import *
from django.forms import *
from jade.common.forms import DynamicForm
		
class AccountForm(DynamicForm):
	def __init__(self, lang, *args, **kwargs):
		super(AccountForm, self).__init__(*args, **kwargs)
		self.make_fields_dynamic(lang, ('name',))

	class Meta:
		model = Account


#class AccountForm(ModelForm):
#	def __init__(self, lang, *args, **kwargs):
#		super(AccountForm, self).__init__(*args, **kwargs)
#		self.fields['name_'+lang] = CharField(max_length=50)
#	class Meta:
##		model = Account
##		fields = ('parent','account_type','number','modifier')

#class TestForm(ModelForm):
#  def __init__(self, lang, *args, **kwargs):
#    super(TestForm, self).__init__(*args, **kwargs)
#    self.fields['name_'+lang] = CharField()
#  class Meta:
#    model = Test
#    fields = ('parent','account_type','number','modifier')
#class AccountForm(Form)
#	name = forms.CharField()
#	parent = forms.ModelChoiceField(Account.objects.all())
#	account_type=ChoiceField(choices=Account.MODIFIER_CHOICES)
#	number = forms.CharField()

