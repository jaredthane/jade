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
	return u'<ul><li><a href="#">%s<!--[if IE 7]><!--></a><!--<![endif]--><!--[if lte IE 6]><table><tr><td><![endif]--><ul>' % label
	
@register.simple_tag
def menu_end():
	return u'</ul><!--[if lte IE 6]></td></tr></table></a><![endif]--></li></ul>'
	
@register.simple_tag
def menu_button(label):
	return u'<ul><li><a href="%s">%s</a></li></ul>' % (url, label)
		
@register.simple_tag
def menu_item(url, label):
	return u'<li><a title="%s" href="%s">%s</a></li>' % (label, url, label)

@register.simple_tag
def breadcrumb(url, label):
	return u'<li><a href="%s">%s</a></li>' % (url, label)
	

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
	
@register.simple_tag
def nav1_link(form_id, label):
	return u'<li><a href="%s" title="%s">Links</a></li>' % (url, label)

@register.simple_tag
def trans_field(form, field, lang):
	try:
		return unicode(form[field+'_'+lang])
	except:
		return form[field+'_es']

	



