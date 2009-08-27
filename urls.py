from django.conf.urls.defaults import *
from django.conf import settings
from jade.accounting import views
from jade.common.views import get_time

# Uncomment the next two lines to enable the admin:
from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    # Example:
    # (r'^jade/', include('jade.foo.urls')),

    # Uncomment the admin/doc line below and add 'django.contrib.admindocs' 
    # to INSTALLED_APPS to enable admin documentation:
    
		(r'^static/(?P<path>.*)$', 'django.views.static.serve',{'document_root': settings.STATIC_DOC_ROOT}),
    (r'^admin/doc/', include('django.contrib.admindocs.urls')),

    url(r'^get_time/$',	get_time, name = 'get_time'),
    # Uncomment the next line to enable the admin:
    (r'^admin/(.*)', admin.site.root),
    (r'^accounting/', include('jade.accounting.urls')),
    (r'^orders/', include('jade.orders.urls')),
    (r'^entities/', include('jade.entities.urls')),
    (r'^auth/', include('jade.auth.urls')),
    (r'^inventory/', include('jade.inventory.urls')),

)