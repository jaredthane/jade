from django.db.models import *

class Poll(Model):
	name = CharField(max_length=50, default='')
	def __unicode__(self):
		return 'Poll:' + str(self.name)

class Option(Model):
	name = CharField(max_length=50, default='')
	poll = ForeignKey(Poll)
	def __unicode__(self):
		return 'Option:' + str(self.name)
	
class Piece(Model):
	name = CharField(max_length=50, default='')
	option = ForeignKey(Option)
	def __unicode__(self):
		return 'Piece:' + str(self.name)
