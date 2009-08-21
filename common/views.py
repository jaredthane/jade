from django.shortcuts import get_object_or_404, render_to_response
from django.utils.translation import ugettext_lazy as _
from django.core.urlresolvers import reverse

def generic_index(request, Model, model_name, app_name):
	object_list = Model.objects.all()
	current_url=request.get_full_path()
	current_lang=request.session['django_language']
	return render_to_response(app_name+'/index_'+model_name.lower()+'s.html', {'object_list': object_list, 'current_url':current_url, 'current_lang':current_lang})

def generic_show(request, object_id, Model, model_name, app_name):
	obj = get_object_or_404(Model, pk=object_id)
	current_url=request.get_full_path()
	current_lang=request.session['django_language']
	return render_to_response(app_name+'/show_'+model_name.lower()+'.html', {'obj': obj, 'current_url':current_url, 'current_lang':current_lang})


def generic_edit(request, Model, Form, model_name, app_name, object_id = None):
	current_lang=request.session['django_language']
	if request.method == 'POST': #POST
		print "POSTING"
		if object_id: #UPDATE
			print "UPDATEING"
			obj = get_object_or_404(Model, pk=object_id)
			print "obj=" + str(obj)
			current_url=reverse('show_'+model_name.lower(), kwargs={'object_id':obj.pk} )
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
			return render_to_response(app_name+'/show_'+model_name.lower()+'.html', {'obj': obj, 'current_url':current_url, 'current_lang':current_lang})
		except ValueError:
			current_url=request.get_full_path()
			return render_to_response(app_name+'/edit_'+model_name.lower()+'.html', {'obj': (obj or None), 'form':form, 'current_url':current_url, 'current_lang':current_lang})
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
	return render_to_response(app_name+'/edit_'+model_name.lower()+'.html', {'obj': obj, 'form':form, 'current_url':current_url, 'current_lang':current_lang})

