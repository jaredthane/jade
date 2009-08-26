from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse
from django.contrib.auth.decorators import login_required
from datetime import datetime
from django.http import HttpResponse

@login_required
def generic_index(request, Model, object_list):
	current_url=request.get_full_path()
	current_lang=request.session['django_language']
	return render_to_response(Model._meta.app_label+'/index_'+Model._meta.verbose_name_plural.lower()+'.html', {'object_list': object_list, 'current_url':current_url, 'current_lang':current_lang, 'model_name':Model._meta.verbose_name, 'model_name_plural':Model._meta.verbose_name_plural})

@login_required
def generic_show(request, object_id, Model):
	obj = get_object_or_404(Model, pk=object_id)
	current_url=request.get_full_path()
	current_lang=request.session['django_language']
	return render_to_response(Model._meta.app_label+'/show_'+Model._meta.verbose_name.lower()+'.html', {'obj': obj, 'current_url':current_url, 'current_lang':current_lang})
	
@login_required
def get_time(request):
  return HttpResponse(datetime.now())

@login_required
def generic_edit(request, Model, Form, object_id = None):
	current_lang=request.session['django_language']
	if request.method == 'POST': #POST
		print "POSTING"
		if object_id: #UPDATE
			print "UPDATEING"
			obj = get_object_or_404(Model, pk=object_id)
			print "obj=" + str(obj)
			current_url=reverse('show_'+Model._meta.verbose_name.lower(), kwargs={'object_id':obj.pk} )
			form = Form(current_lang, request.POST, instance=obj)
		else: #CREATE
			print "CREATE"
			form = Form(current_lang, request.POST)
		try:
			obj=None
			obj=form.save()
#			print "obj2=" + str(obj)
#			print "obj.revenue_account=" + str(obj.revenue_account)
			current_url=reverse('show_'+model_name.lower(), kwargs={'object_id':obj.pk} )
			return render_to_response(Model._meta.app_label+'/show_'+Model._meta.verbose_name.lower()+'.html', {'obj': obj, 'current_url':current_url, 'current_lang':current_lang})
		except ValueError:
			current_url=request.get_full_path()
			return render_to_response(Model._meta.app_label+'/edit_'+Model._meta.verbose_name.lower()+'.html', {'obj': (obj or None), 'form':form, 'current_url':current_url, 'current_lang':current_lang})
	else: # GET
		print "GETTING"
		current_url=request.get_full_path()
		if object_id: #EDIT
			print "EDITING"
			obj = get_object_or_404(Model, pk=object_id)
			form = Form(current_lang, instance=obj)
		else: #NEW
			print "NEW"
			obj=None
			form=Form(current_lang)
	return render_to_response(Model._meta.app_label+'/edit_'+Model._meta.verbose_name.lower()+'.html', {'obj': obj, 'form':form, 'current_url':current_url, 'current_lang':current_lang})

