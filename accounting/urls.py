from django.conf.urls.defaults import *
from jade.accounting.views import *
urlpatterns = patterns('jade.accounting.views',
    url(r'^$', 															index,name='index_account'),
    url(r'^(?P<account_id>\d+)/$', 					show, name='show_account'),
    url(r'^(?P<account_id>\d+)/edit/$', 		edit, name='edit_account'),
    url(r'^new/$', 													edit, name="new_account"),

)

