from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponseRedirect
from django.shortcuts import render_to_response
from django.utils.translation import ugettext_lazy as _
from settings import LOGIN_REDIRECT_URL, LANGUAGE_CODE

def login_view(request):
	if 'django_language' in request.session: 
		current_lang=request.session['django_language']
	else:
		request.session['django_language']=LANGUAGE_CODE
	if request.method == 'POST': #POST
		username = request.POST['username']
		password = request.POST['password']
		user = authenticate(username=username, password=password)
		if user is not None:
			if user.is_active:
				login(request, user)
				return HttpResponseRedirect(LOGIN_REDIRECT_URL)
			else:
				error_message=_("This account has been disabled, please contact your system administrator")
				return render_to_response('auth/login.html', {'error_message': error_message, 'current_url':request['HTTP_REFERER']})
		else:
			error_message=_("The username and password combination you entered is not correct. Please try again")
			return render_to_response('auth/login.html', {'error_message': error_message, 'current_url':request['HTTP_REFERER']})
	else: #GET
		return render_to_response('auth/login.html', {})
def logout_view(request):
  logout(request)
  info_message=_("You have been logged out sucessfully.")
  return render_to_response('auth/login.html', {'info_message': info_message, 'current_url':request['HTTP_REFERER']})

def set_language(request):
#	print "request.GET.get('lang', 'en')=" + str(request.GET.get('lang', 'en'))
#	print "request.session['django_language']=" + str(request.session['django_language'])
	request.session['django_language'] = request.GET.get('lang', 'en')
	return HttpResponseRedirect(request.GET.get('back', LOGIN_REDIRECT_URL))
