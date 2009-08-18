from django.conf.urls.defaults import *
urlpatterns = patterns('jade.accounting.views',
    (r'^$', 'index'),
    (r'^(?P<account_id>\d+)/$', 'show'),
    (r'^(?P<account_id>\d+)/edit/$', 'edit'),
)

