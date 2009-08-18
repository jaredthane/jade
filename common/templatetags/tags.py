from django import template
register = template.Library()

# Order of things:
# url, label, value, width
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

@register.simple_tag
def table_cell_link(url, label, width=None):
	if width:
		return u'<div class="table_cell_%s"><a href="%s">%s</a></div>' % (width, url, label)
	else:
		return u'<div class="table_cell"><a href="%s">%s</a></div>' % (url, label)

@register.simple_tag
def detail_item(label, value, url=None):
	if url:
		return u'<p><b>%s: </b><a href="%s">%s</a></p>' % (label, url, (value or ""))
	else:
		return u'<p><b>%s: </b>%s</p>' % (label, (value or ""))
		
@register.simple_tag
def action(url, label):
	return u'<dt><a href="%s">%s</a></dt>' % (url, label)
	
@register.simple_tag
def link_heading(url, label):
	return u'<dt><a href="%s">%s</a></dt>' % (url, label)
	
@register.simple_tag
def link_heading(url, label):
	return u'<dd><a href="%s">%s</a></dd>' % (url, label)
	
@register.simple_tag
def submit_link(form_id, label):
	return u'<dt><a href="javascript:document.%s.submit();">%s</a></dt>' % (form_id, label)
	

	

	



