from django.conf.urls.defaults import *
from jade.entities.views import *
urlpatterns = patterns('jade.entities.views',
    url(r'^sites/$', 															index_sites, name = 'index_sites'),
    url(r'^site/(?P<object_id>\d+)/$', 						show_site, name = 'show_site'),
    url(r'^edit_site/(?P<object_id>\d+)/$', 			edit_site, name = 'edit_site'),
    url(r'^new_site/$', 													edit_site, name = 'new_site'),
    
    url(r'^clients/$', 													index_clients, name = 'index_clients'),
    url(r'^client/(?P<object_id>\d+)/$', 				show_client, name = 'show_client'),
    url(r'^edit_client/(?P<object_id>\d+)/$', 	edit_client, name = 'edit_client'),
    url(r'^new_client/$', 											edit_client, name = 'new_client'),
    
    url(r'^vendors/$', 													index_vendors, name = 'index_vendors'),
    url(r'^vendor/(?P<object_id>\d+)/$', 				show_vendor, name = 'show_vendor'),
    url(r'^edit_vendor/(?P<object_id>\d+)/$', 	edit_vendor, name = 'edit_vendor'),
    url(r'^new_vendor/$', 											edit_vendor, name = 'new_vendor'),
    
)
