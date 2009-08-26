from django.conf.urls.defaults import *
from jade.orders.views import *
urlpatterns = patterns('jade.orders.views',
    url(r'^sales/$', 															index_sales, name = 'index_sales'),
    url(r'^sale/(?P<object_id>\d+)/$', 						show_sale, name = 'show_sale'),
    url(r'^edit_sale/(?P<object_id>\d+)/$', 			edit_sale, name = 'edit_sale'),
    url(r'^new_sale/$', 													edit_sale, name = 'new_sale'),
    
    url(r'^purchases/$', 													index_purchases, name = 'index_purchases'),
    url(r'^purchase/(?P<object_id>\d+)/$', 				show_purchase, name = 'show_purchase'),
    url(r'^edit_purchase/(?P<object_id>\d+)/$', 	edit_purchase, name = 'edit_purchase'),
    url(r'^new_purchase/$', 											edit_purchase, name = 'new_purchase'),
    
    url(r'^new_line/$', 											edit_line, name = 'new_line'),

)

