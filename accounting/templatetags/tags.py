from django import template
register = template.Library()

@register.filter
def str_to_h1(s):
	return u'<h1>%s</h1>' % s

@register.filter
def str_to_p(s):
	return u'<p>%s</p>' % s

@register.simple_tag
def menu_start(label):
	return u'<li><a title="%s"><ul>' % label

@register.simple_tag
def menu_end():
	return u'</ul></li>'
	
@register.simple_tag
def menu_item(url, label):
	return u'<li><a title="%s" href="%s">%s</a></ul>' % (label, url, label)

@register.simple_tag
def table_cell(label, width=None):
	if width:
		return u'<div class="table_cell_%s">%s</div>' % (width, label)
	else:
		return u'<div class="table_cell">%s</div>' % label
		


