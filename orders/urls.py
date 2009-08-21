from django.conf.urls.defaults import *
from jade.orders.views import *
urlpatterns = patterns('jade.orders.views',
    url(r'^sales/$', 															index_sales, name = 'index_sales'),
    url(r'^sales/(?P<order_id>\d+)/$', 						show_sale, name = 'show_sale'),
    url(r'^sales/(?P<order_id>\d+)/edit/$', 			edit_sale, name = 'edit_sale'),
    url(r'^sales/new/$', 													edit_sale, name = 'new_sale'),
    
    url(r'^purchases/$', 													index_purchases, name = 'index_purchases'),
    url(r'^purchases/(?P<order_id>\d+)/$', 				show_purchase, name = 'show_purchase'),
    url(r'^purchases/(?P<order_id>\d+)/edit/$', 	edit_purchase, name = 'edit_purchase'),
    url(r'^purchases/new/$', 											edit_purchase, name = 'new_purchase'),

)

