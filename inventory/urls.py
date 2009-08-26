from django.conf.urls.defaults import *
from jade.inventory.views import *
urlpatterns = patterns('jade.inventory.views',
    url(r'^products/$', 															index_products,name='index_products'),
    url(r'^product/(?P<object_id>\d+)/$', 					show_product, name='show_product'),
    url(r'^edit_product/(?P<object_id>\d+)/edit/$', 		edit_product, name='edit_product'),
    url(r'^new_product/$', 													edit_product, name="new_product"),

)

