from django.conf.urls.defaults import *
from jade.orders.views import *
urlpatterns = patterns('jade.orders.views',
    url(r'^sales/$', 															index_sales, name = 'index_sales'),
    url(r'^sale/(?P<order_id>\d+)/$', 						show_sale, name = 'show_sale'),
    url(r'^sale/(?P<order_id>\d+)/edit/$', 			edit_sale, name = 'edit_sale'),
    url(r'^sale/new/$', 													edit_sale, name = 'new_sale'),
    
    url(r'^purchases/$', 													index_purchases, name = 'index_purchases'),
    url(r'^purchase/(?P<order_id>\d+)/$', 				show_purchase, name = 'show_purchase'),
    url(r'^purchase/(?P<order_id>\d+)/edit/$', 	edit_purchase, name = 'edit_purchase'),
    url(r'^purchase/new/$', 											edit_purchase, name = 'new_purchase'),
    
    url(r'^line/new/$', 											edit_line, name = 'new_line'),

)

