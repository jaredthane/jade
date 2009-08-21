from django.forms import *

class DynamicForm(ModelForm):
	def make_fields_dynamic(self, lang, dynamic_fields):
		fields_to_remove=[]
		for field in self.fields:
			if field[:-3] in dynamic_fields:
				if field[-2:] != lang:
					fields_to_remove.append(field)
		for field in fields_to_remove:
			del self.fields[field]
