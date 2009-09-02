from django import template

from django.core.urlresolvers import reverse

from django.utils.translation import ugettext_lazy as _
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
def menu_button(url, label):
	return u'<ul><li><a href="%s">%s</a></li></ul>' % (url, label)
		
@register.simple_tag
def menu_item(url, label):
	return u'<li><a title="%s" href="%s">%s</a></li>' % (label, url, label)

@register.simple_tag
def breadcrumb(url, label):
	return u'<li><a href="%s">%s</a></li>' % (url, label)
@register.simple_tag
def link(url, label):
	return u'<a href="%s">%s</a>' % (url, label)

@register.simple_tag
def table_cell(label, width=None):
	if width:
		return u'<div class="table_cell_%s">%s</div>' % (width, label)
	else:
		return u'<div class="table_cell">%s</div>' % label

@register.simple_tag
def table_cell_date(label, width=None):
	if label:
		if width:
			return u'<div class="table_cell_%s">%s</div>' % (width, label.strftime("%m/%d/%Y"))
		else:
			return u'<div class="table_cell">%s</div>' % label.strftime("%m/%d/%Y")
	else:
		if width:
			return u'<div class="table_cell_%s"></div>' % width
		else:
			return u'<div class="table_cell"></div>'
		

@register.simple_tag
def date_format(value, format):
	if value:
		return u'%s' % value.strftime(format)
	else:
		return u''

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
def detail_item_date(label, value, url=None):
	if value:
		if url:
			return u'<p><b>%s: </b><a href="%s">%s</a></p>' % (label, url, value.strftime("%m/%d/%Y"))
		else:
			return u'<p><b>%s: </b>%s</p>' % (label, value.strftime("%m/%d/%Y"))
	else:
		if url:
			return u'<p><b>%s: </b><a href="%s"></a></p>' % (label, url)
		else:
			return u'<p><b>%s: </b></p>' % label
		
		
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

#@register.simple_tag
#def trans_field(form, field, lang):
#	try:
#		return unicode(form[field+'_'+lang])
#	except:
#		return form[field+'_es']

@register.simple_tag
def form_field(field, label):
	return u'%s<p><b>%s: </b>%s</p>' % (field.errors, label, field)
	
	
@register.simple_tag
def trans_field(form, field, lang, label):
	try:
		t_field= unicode(form[field+'_'+lang])
		t_errors= unicode(form[field+'_'+lang].errors)
		return u'%s<p><b>%s: </b>%s</p>' % (t_errors, label, t_field)
	except:
		t_field= form[field+'_es']
		t_errors= unicode(form[field+'_es'].errors)
		return u'%s<p><b>%s: </b>%s</p>' % (t_errors, label, t_field)

@register.simple_tag
def show_actions(model_name, new_label, edit_label, index_label, obj):
	index_url=reverse('index_'+model_name.lower()+'s')
	edit_url=reverse('edit_'+model_name.lower(), kwargs={'object_id':obj.pk} )
	new_url=reverse('new_'+model_name.lower() )
	return u'%s%s%s' % (action(edit_url, edit_label), action(new_url, new_label), action(index_url, index_label))

@register.simple_tag
def edit_actions(model_name, save_label, cancel_label, index_label, obj=None):
	index_url=reverse('index_'+model_name.lower()+'s')
	save_action=submit_link(model_name+'_form', save_label)
	print "obj=" + str(obj)
	if obj:
		if obj.pk:
			show_url=reverse('show_'+model_name.lower(), kwargs={'object_id':obj.pk} )
			return u'%s%s%s' % (save_action, action(index_url, index_label), action(show_url, cancel_label))
	return u'%s%s' % (save_action, action(index_url, cancel_label))
		
@register.simple_tag
def index_actions(model_name, new_label):
	new_url=reverse('new_'+model_name.lower())
	return u'%s' % (action(new_url, new_label))
	
