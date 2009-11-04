from jade.tester.models import *
from django.forms import *
from django.forms.formsets import formset_factory
from django.forms.models import inlineformset_factory

class PollForm(ModelForm):
	class Meta:
		model = Poll
	def __init__(self, *args, **kwargs):
		super(PollForm, self).__init__(*args, **kwargs)
#		if self.prefix: 
#			self.prefix+="_poll"
		print "poll.prefix=" + (self.prefix or '')
		if len(self.data)==0:
			self.options_formset = OptionFormSet(instance=self.instance, prefix=self.prefix)
		else:
			self.options_formset = OptionFormSet(instance=self.instance, data=self.data, prefix=self.prefix)
	def save(self):
		print "Saving Poll"
		result = super(PollForm, self).save()
		print "Saving Options"
		for form in self.options_formset.forms:
			form.save()
		return result
	def is_valid(self):
		ok = True
		ok = ok and super(PollForm, self).is_valid()
		ok = ok and self.options_formset.is_valid()
		return ok
		
class OptionForm(ModelForm):
	class Meta:
		model = Option
	def __init__(self, *args, **kwargs):
		super(OptionForm, self).__init__(*args, **kwargs)
#		if self.prefix: 
#			self.prefix+="_option"
#		else:
#			self.prefix='option'
		print "option.prefix=" + self.prefix
		if len(self.data)==0:
			self.pieces_formset = PieceFormSet(instance=self.instance, prefix=self.prefix+"_piece-set")
		else:
			self.pieces_formset = PieceFormSet(instance=self.instance, data=self.data, prefix=self.prefix+"_piece-set")
	def save(self):
		print "Saving Option"
		result = super(OptionForm, self).save()
		print "Saving Piece"
		for form in self.pieces_formset.forms:
			form.save()
		return result
	def is_valid(self):
		ok = True
		ok = ok and super(OptionForm, self).is_valid()
		ok = ok and self.pieces_formset.is_valid()
		return ok

class PieceForm(ModelForm):
	class Meta:
		model = Piece
	def __init__(self, *args, **kwargs):
		super(PieceForm, self).__init__(*args, **kwargs)
#		if self.prefix: 
#			self.prefix+="_piece-set"
		print "piece.prefix=" + self.prefix
		
OptionFormSet =  inlineformset_factory(Poll, Option, extra=0, form=OptionForm)
PieceFormSet =  inlineformset_factory(Option, Piece, extra=0, form=PieceForm)
