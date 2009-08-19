from django.conf.urls.defaults import *
from jade.auth.views import *
urlpatterns = patterns('jade.auth.views',
    url(r'^login/$', 												login_view,name='login'),
    url(r'^logout/$', 											logout_view,name='logout'),
    url(r'^set_language/$', set_language,name='set_language'),
)

