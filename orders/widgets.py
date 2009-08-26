from django.forms import Widget
from django.utils.safestring import mark_safe
class StaticText(Widget):
	def render(self, name, value, attrs=None):
		if value is None: value = ''
		return mark_safe(u'%s' % value)

#class StaticText(Widget):
#	def render(self, name, value, attrs=None):
#		if value is None: value = ''
#		return mark_safe(u'%s' % value)
#		
#class Input(Widget):
#    """
#    Base class for all <input> widgets (except type='checkbox' and
#    type='radio', which are special).
#    """
#    input_type = None # Subclasses must define this.

#    def render(self, name, value, attrs=None):
#        if value is None: value = ''
#        final_attrs = self.build_attrs(attrs, type=self.input_type, name=name)
#        if value != '':
#            # Only add the 'value' attribute if a value is non-empty.
#            final_attrs['value'] = force_unicode(value)
#        return mark_safe(u'<input%s />' % flatatt(final_attrs))
