from django.conf.urls.defaults import *
from jade.orders.views import *
urlpatterns = patterns('jade.orders.views',
    url(r'^$', 															index,name='index_orders'),
    url(r'^(?P<object_id>\d+)/$', 					show, name='show_order'),
    url(r'^(?P<object_id>\d+)/edit/$', 		edit, name='edit_order'),
    url(r'^new/$', 													edit, name="new_order"),

)

