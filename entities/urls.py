from django.conf.urls.defaults import *
from jade.entities.views import *
urlpatterns = patterns('jade.entities.views',
    url(r'^sites/$', 															index_sites, name = 'index_sites'),
    url(r'^sites/(?P<object_id>\d+)/$', 						show_site, name = 'show_site'),
    url(r'^sites/(?P<object_id>\d+)/edit/$', 			edit_site, name = 'edit_site'),
    url(r'^sites/new/$', 													edit_site, name = 'new_site'),
    
    url(r'^clients/$', 													index_clients, name = 'index_clients'),
    url(r'^clients/(?P<object_id>\d+)/$', 				show_client, name = 'show_client'),
    url(r'^clients/(?P<object_id>\d+)/edit/$', 	edit_client, name = 'edit_client'),
    url(r'^clients/new/$', 											edit_client, name = 'new_client'),
    
    url(r'^vendors/$', 													index_vendors, name = 'index_vendors'),
    url(r'^vendors/(?P<object_id>\d+)/$', 				show_vendor, name = 'show_vendor'),
    url(r'^vendors/(?P<object_id>\d+)/edit/$', 	edit_vendor, name = 'edit_vendor'),
    url(r'^vendors/new/$', 											edit_vendor, name = 'new_vendor'),
    
)
