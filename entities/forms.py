from jade.common.forms import DynamicForm
from jade.entities.models import *

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

	class Meta:
		model = Site
