from django.db.models import *
from datetime import datetime
from decimal import Decimal
from transmeta import TransMeta
from django.utils.translation import ugettext_lazy as _
MODIFIER_CHOICES = ((1, _('Debit')),(-1, _('Credit')),)

class DirtyMixin(object):
	def __init__(self, *args, **kwargs):
		  super(DirtyMixin, self).__init__(*args, **kwargs)
		  self._original_state = dict(self.__dict__)
	def save(self, *args, **kwargs):
		state = dict(self.__dict__)
		del state['_original_state']
		self._original_state = state
		super(DirtyMixin, self).save()
	def old_value(self, key):
		return self._original_state[key]
	def is_new(self):
		if not self.pk:
			return True
		else:
			return False
	def is_dirty(self):
		if not self.pk:
			return True
		missing = object()
		result = {}
		for key, value in self._original_state.iteritems():
		  if value != self.__dict__.get(key, missing):
				return True
		return False
	def changed_columns(self):
		result = {}
		if not self.pk: # Never been saved to the db, return all fields
			for key, value in dict(self.__dict__).iteritems():
				if value:
					result[key] = {'old':None, 'new':value}
			del result['_original_state']
			return result
		missing = object()
		for key, value in self._original_state.iteritems():
		  if value != self.__dict__.get(key, missing):
				result[key] = {'old':value, 'new':self.__dict__.get(key, missing)}
		return result
		
class Account(Model):
	__metaclass__ = TransMeta
	name = CharField(max_length=50, default='')
	number = CharField(max_length=50, default='')
	modifier = IntegerField(choices=MODIFIER_CHOICES)
	parent = ForeignKey('Account', blank=True, default=None, null=True)
	class Meta:
		verbose_name_plural = _('Accounts')
		verbose_name = _('Account')
		translate = ('name', )
	def all_parent_accounts(self):
		try:
			return [parent] + parent.all_parent_accounts()
		except:
			return []
	def get_display(self):
		return self.number + ": " + self.name
	display=property(get_display)
	def get_balance(self):
		return self.entry_set.latest().balance
	balance = property(get_balance)
	def save(self, *args, **kwargs):
		super(Account, self).save()
		for p in self.entry_set.all():
			p.save()
	def __unicode__(self):
		return str(self.number) + " - " + self.name + " (" + self.get_modifier_display() + ")"
	@permalink
	def get_absolute_url(self):
		return ('accounting.show_account', None, { 'object_id': self.id })
		
class Transaction(DirtyMixin, Model):
	"""
#	# Create an account and a transaction
#	>>> a=Account.objects.get(number="1011")
#	>>> a2=Account.objects.get(number="2011")
#	>>> a3=Account.objects.get(number="3011")
#	>>> t=Transaction(date=datetime(2009,5,12))
#	>>> t.add_entry(a, 1)
#	<Entry: Debit 1011: First Account $1 balance-> None>
#	>>> t.add_entry(a3, -1)
#	<Entry: Debit 3011: Third Account $-1 balance-> None>
#	
#	# Test the DirtyMixin
#	>>> t.entries[0].is_dirty()
#	True
#	>>> t.entries[0].changed_columns()
#	{'_account_cache': {'new': <Account: 1011 - First Account (Debit)>, 'old': None}, 'value': {'new': 1, 'old': None}, 'account_id': {'new': 1, 'old': None}, 'date': {'new': datetime.datetime(2009, 5, 12, 0, 0), 'old': None}, 'modifier': {'new': 1, 'old': None}}
#	
#	# Make sure the transaction is balanced
#	>>> t.out_of_balance()
#	False
#	
#	# Try saving this balanced transaction
#	>>> t.save()
#	True
#	>>> a.entry_set.all()
#	[<Entry: Debit 1011: First Account $1 balance-> 1>, <Entry: Credit 1011: First Account $4.54 balance-> -3.54>]
#	>>> a3.entry_set.all()
#	[<Entry: Credit 3011: Third Account $1 balance-> 1>]
#	>>> t.entries
#	[<Entry: Debit 1011: First Account $1 balance-> 1>, <Entry: Credit 3011: Third Account $1 balance-> 1>]
#	
#	
##	# Now lets shuffle things around a bit and make sure it gets saved right
##	>>> t.add_entry(account=a, value=3)
##	<Entry: Debit 1011: First Account $3 balance-> None>
##	>>> t.add_entry(account=a3, value=-2)
##	<Entry: Debit 3011: Third Account $-2 balance-> None>
##	>>> p=t.entries[0]
##	>>> t.remove_entry(p)
##	>>> t.entries
##	[<Entry: Credit 3011: Third Account $1 balance-> 1>, <Entry: Debit 1011: First Account $3 balance-> None>, <Entry: Debit 3011: Third Account $-2 balance-> None>]
##	>>> t._remove_duplicate_entries()
##	>>> t.entries
##	[<Entry: Debit 1011: First Account $3 balance-> None>, <Entry: Credit 3011: Third Account $3 balance-> None>]
##	>>> t._balance()
##	0
##	>>> t.out_of_balance()
##	False
##	>>> t.validate_entries()
##	True
##	>>> len(t.entries)
##	2
##	>>> t.entries
##	[<Entry: Debit 1011: First Account $3 balance-> None>, <Entry: Credit 3011: Third Account $3 balance-> None>]
##	>>> a3.entry_set.all()
##	[<Entry: Credit 3011: Third Account $1 balance-> 1>]
##	>>> t.save()
##	True
##	>>> t.entries
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $3 balance-> 3>]
##	>>> a3.entry_set.all()
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>]
##	>>> t.entries
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $3 balance-> 3>]
##	>>> Entry.objects.all()
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>, <Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Credit 1011: First Account $4.54 balance-> -1.54>, <Entry: Debit 2011: Second Account $4.54 balance-> 4.54>]
##	
##	# Good. Now lets try making the transaction unbalanced and see if it gets saved...
##	>>> p=t.entries[0]
##	>>> t.entries
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $3 balance-> 3>]
##	>>> t.remove_entry(p)
##	>>> t.entries
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>]
##	>>> t.save()
##	False
##	
##	# Notice that the transaction still has unbalanced entries...
##	>>> t.entries
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>]
##	>>> t.out_of_balance()
##	True
##	
##	# But the copy in the db is still the latest balanced version...
##	# Let's try resetting it back to the valid version...
##	>>> t.reset()
##	>>> t.entries
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>, <Entry: Debit 1011: First Account $3 balance-> 3>]
##	
##	# Lets play with the dates a little bit...
##	# notice it matches the date we put
##	>>> t.entries[0].date
##	datetime.datetime(2009, 5, 12, 0, 0)
##	>>> Transaction.objects.all()
##	[<Transaction: 2 - 2009-05-12 00:00:00>, <Transaction: 1 - 2009-06-16 00:00:00>]
##	>>> t=Transaction(date=datetime(2009,5,14))
##	>>> p1=t.add_entry(a,3)
##	>>> p1.changed_columns()
##	{'_account_cache': {'new': <Account: 1011 - First Account (Debit)>, 'old': None}, 'value': {'new': 3, 'old': None}, 'account_id': {'new': 1, 'old': None}, 'date': {'new': datetime.datetime(2009, 5, 14, 0, 0), 'old': None}, 'modifier': {'new': 1, 'old': None}}
##	>>> p2=t.add_entry(a2, -3)
##	>>> p2.changed_columns()
##	{'_account_cache': {'new': <Account: 2011 - Second Account (Debit)>, 'old': None}, 'value': {'new': -3, 'old': None}, 'account_id': {'new': 2, 'old': None}, 'date': {'new': datetime.datetime(2009, 5, 14, 0, 0), 'old': None}, 'modifier': {'new': 1, 'old': None}}
##	>>> t.validate_entries()
##	True
##	>>> t.save()
##	True
##	>>> t.entries
##	[<Entry: Debit 1011: First Account $3 balance-> 6>, <Entry: Credit 2011: Second Account $3 balance-> -3>]
##	>>> p1.changed_columns()
##	{'id': {'new': 6, 'old': None}}
##	>>> p2.changed_columns()
##	{'id': {'new': 7, 'old': None}}
##	
##	# Lets make another one for the 16th
##	>>> t=Transaction(date=datetime(2009,5,16))
##	>>> t.add_entry(a2, 4)
##	<Entry: Debit 2011: Second Account $4 balance-> None>
##	>>> t.add_entry(a3, -4)
##	<Entry: Debit 3011: Third Account $-4 balance-> None>
##	>>> t.save()
##	True
##	
##	# Heres one that has duplicate accounts and cancels out to zero.
##	# wont save
##	>>> t2=Transaction(date=datetime(2009,5,17))
##	>>> t2.add_entry(a, 1)
##	<Entry: Debit 1011: First Account $1 balance-> None>
##	>>> t2.add_entry(a, -1)
##	<Entry: Debit 1011: First Account $-1 balance-> None>
##	>>> t2.save()
##	False
##	>>> a.entry_set.all()
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Debit 1011: First Account $3 balance-> 6>, <Entry: Credit 1011: First Account $4.54 balance-> 1.46>]
##	>>> a2.entry_set.all()
##	[<Entry: Credit 2011: Second Account $3 balance-> -3>, <Entry: Debit 2011: Second Account $4 balance-> 1>, <Entry: Debit 2011: Second Account $4.54 balance-> 5.54>]
##	>>> a3.entry_set.all()
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $4 balance-> 7>]
##	
##	# Now we'll make it valid and save it with on the 17th
##	>>> t2.add_entry(a2, 5)
##	<Entry: Debit 2011: Second Account $5 balance-> None>
##	>>> t2.add_entry(a3, -5)
##	<Entry: Debit 3011: Third Account $-5 balance-> None>
##	>>> t2.save()
##	True
##	
##	# lets make one more for the 18th to see a clear view
##	# this one will have 3 fields but will be balanced
##	>>> t=Transaction(date=datetime(2009,5,18))
##	>>> t.add_entry(a, 7)
##	<Entry: Debit 1011: First Account $7 balance-> None>
##	>>> t.add_entry(a2, -4)
##	<Entry: Debit 2011: Second Account $-4 balance-> None>
##	>>> t.add_entry(a3, -3)
##	<Entry: Debit 3011: Third Account $-3 balance-> None>
##	>>> t.save()
##	True
##	
##	# Check to see what the books look like:
##	>>> a.entry_set.all()
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Debit 1011: First Account $3 balance-> 6>, <Entry: Debit 1011: First Account $7 balance-> 13>, <Entry: Credit 1011: First Account $4.54 balance-> 8.46>]
##	>>> a2.entry_set.all()
##	[<Entry: Credit 2011: Second Account $3 balance-> -3>, <Entry: Debit 2011: Second Account $4 balance-> 1>, <Entry: Debit 2011: Second Account $5 balance-> 6>, <Entry: Credit 2011: Second Account $4 balance-> 2>, <Entry: Debit 2011: Second Account $4.54 balance-> 6.54>]
##	>>> a3.entry_set.all()
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $4 balance-> 7>, <Entry: Credit 3011: Third Account $5 balance-> 12>, <Entry: Credit 3011: Third Account $3 balance-> 15>]
##	
##	# Now lets try moving the transaction from the 17th to the 15th
##	>>> t2.date=datetime(2009,5,15)
##	>>> t2.save()
##	True
##	
##	# Now what do we have?
##	>>> Account.objects.get(pk=1).entry_set.all()
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Debit 1011: First Account $3 balance-> 6>, <Entry: Debit 1011: First Account $7 balance-> 13>, <Entry: Credit 1011: First Account $4.54 balance-> 8.46>]
##	>>> Account.objects.get(pk=2).entry_set.all()
##	[<Entry: Credit 2011: Second Account $3 balance-> -3>, <Entry: Debit 2011: Second Account $5 balance-> 2>, <Entry: Debit 2011: Second Account $4 balance-> 6>, <Entry: Credit 2011: Second Account $4 balance-> 2>, <Entry: Debit 2011: Second Account $4.54 balance-> 6.54>]
##	>>> Account.objects.get(pk=3).entry_set.all()
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $5 balance-> 8>, <Entry: Credit 3011: Third Account $4 balance-> 12>, <Entry: Credit 3011: Third Account $3 balance-> 15>]
##	
##	# Try changing a modifier
##	>>> t=Transaction.objects.get(pk=3)
##	>>> p1=t.entries[0]
##	>>> p2=t.entries[1]
##	>>> p1.modifier, p2.modifier = -1, 1
##	>>> t.save()
##	True
##	>>> Account.objects.get(pk=1).entry_set.all()
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Credit 1011: First Account $3 balance-> 0>, <Entry: Debit 1011: First Account $7 balance-> 7>, <Entry: Credit 1011: First Account $4.54 balance-> 2.46>]
##	>>> Account.objects.get(pk=2).entry_set.all()
##	[<Entry: Debit 2011: Second Account $3 balance-> 3>, <Entry: Debit 2011: Second Account $5 balance-> 8>, <Entry: Debit 2011: Second Account $4 balance-> 12>, <Entry: Credit 2011: Second Account $4 balance-> 8>, <Entry: Debit 2011: Second Account $4.54 balance-> 12.54>]

##	# Try changing a value
##	>>> p1.value, p2.value=7,7
##	>>> t.save()
##	True
##	>>> Account.objects.get(pk=1).entry_set.all()
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Credit 1011: First Account $7 balance-> -4>, <Entry: Debit 1011: First Account $7 balance-> 3>, <Entry: Credit 1011: First Account $4.54 balance-> -1.54>]
##	>>> Account.objects.get(pk=2).entry_set.all()
##	[<Entry: Debit 2011: Second Account $7 balance-> 7>, <Entry: Debit 2011: Second Account $5 balance-> 12>, <Entry: Debit 2011: Second Account $4 balance-> 16>, <Entry: Credit 2011: Second Account $4 balance-> 12>, <Entry: Debit 2011: Second Account $4.54 balance-> 16.54>]

##	# Try changing an account number
##	>>> p1.account=a3
##	>>> t.entries
##	[<Entry: Credit 3011: Third Account $7 balance-> -4>, <Entry: Debit 2011: Second Account $7 balance-> 7>]
##	>>> t.save()
##	True
##	>>> Account.objects.get(pk=1).entry_set.all()
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Debit 1011: First Account $7 balance-> 10>, <Entry: Credit 1011: First Account $4.54 balance-> 5.46>]
##	>>> Account.objects.get(pk=2).entry_set.all()
##	[<Entry: Debit 2011: Second Account $7 balance-> 7>, <Entry: Debit 2011: Second Account $5 balance-> 12>, <Entry: Debit 2011: Second Account $4 balance-> 16>, <Entry: Credit 2011: Second Account $4 balance-> 12>, <Entry: Debit 2011: Second Account $4.54 balance-> 16.54>]
##	>>> Account.objects.get(pk=3).entry_set.all()
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $7 balance-> 10>, <Entry: Credit 3011: Third Account $5 balance-> 15>, <Entry: Credit 3011: Third Account $4 balance-> 19>, <Entry: Credit 3011: Third Account $3 balance-> 22>]
##	
##	# Try a mean mix
##	>>> t.entries
##	[<Entry: Debit 2011: Second Account $7 balance-> 7>, <Entry: Credit 3011: Third Account $7 balance-> 10>]
##	>>> p1.account=a
##	>>> p1.value, p2.value=9,9	
##	>>> p1.modifier, p2.modifier = 1, -1
##	>>> t.date = datetime(2009,6,30)
##	>>> t.entries
##	[<Entry: Credit 2011: Second Account $9 balance-> 7>, <Entry: Debit 1011: First Account $9 balance-> 10>]
##	>>> t.save()
##	True
##	>>> Account.objects.get(pk=1).entry_set.all()
##	[<Entry: Debit 1011: First Account $3 balance-> 3>, <Entry: Debit 1011: First Account $7 balance-> 10>, <Entry: Credit 1011: First Account $4.54 balance-> 5.46>, <Entry: Debit 1011: First Account $9 balance-> 14.46>]
##	>>> Account.objects.get(pk=2).entry_set.all()
##	[<Entry: Debit 2011: Second Account $5 balance-> 5>, <Entry: Debit 2011: Second Account $4 balance-> 9>, <Entry: Credit 2011: Second Account $4 balance-> 5>, <Entry: Debit 2011: Second Account $4.54 balance-> 9.54>, <Entry: Credit 2011: Second Account $9 balance-> 0.54>]
##	>>> Account.objects.get(pk=3).entry_set.all()
##	[<Entry: Credit 3011: Third Account $3 balance-> 3>, <Entry: Credit 3011: Third Account $5 balance-> 8>, <Entry: Credit 3011: Third Account $4 balance-> 12>, <Entry: Credit 3011: Third Account $3 balance-> 15>]
##	
##	# NEED to make sure its impossible to have two transactions with the exact same time
	"""
	def add_entry(self, account, value, modifier=1):
		p=Entry(account=account, value=value, date=self.date)
		self.entries.append(p)
		return p
	def remove_entry(self, entry):
		self.entries.remove(entry)
	def reset(self):
		self.entries=list(self.entry_set.all())
	def out_of_balance(self):
		return bool(sum([t.value * t.modifier for t in self.entries]))
	def _balance(self):
		return sum([t.value * t.modifier for t in self.entries])
	def save_entries(self):
		dblist=list(self.entry_set.all())
		# Save all existing entries
		for entry in self.entries:
			entry.transaction=self	# make sure its ours
			entry.date=self.date		# update the date if necisary
			entry.save()						# save it
			if entry in dblist:
				dblist.remove(entry) 	# remove from todo list
		for entry in dblist:			# these are leftovers
			for p in entry.account.entry_set.filter(date__gt=entry.date):
				p.balance -= entry.value #!!!!!!!!!!!!!!!!*entry.modifier*entry.account.modifier
				p.save()
			entry.delete()
			
	def __init__(self, *args, **kwargs):
		super(Transaction, self).__init__(*args, **kwargs)
		self.entries = list(self.entry_set.all())
	def _combine_entries(self, entry1, entry2):
		# If we are combining, there's no way both of the entries are already saved
		# if one of the two has been saved, save to it again
		# there aught to be a shorter way to code this
		if entry1.pk:
			keeper=entry1
		else:
			keeper=entry2
		# Now add up the values
		total=(entry1.modifier*entry1.value) + (entry2.modifier*entry2.value)
		if total==0:
			return None
		keeper.modifier=total/abs(total)
		keeper.value=abs(total)
		keeper.balance=None
		return entry1
	def _remove_duplicate_entries(self):
		used_accounts={}
		for entry in self.entries:
			if entry.value < 0:
				entry.value=entry.value*-1
				entry.modifier=entry.modifier*-1
			if (not entry.account in used_accounts) and (entry.value > 0):
				used_accounts[entry.account]=entry
			elif (entry.account in used_accounts) and (entry.value > 0):
				c=self._combine_entries(used_accounts[entry.account], entry)
				if c:
					used_accounts[entry.account]=c
				else:
					del used_accounts[entry.account]
		self.entries=used_accounts.values()
	def validate_entries(self):
		return (not self.out_of_balance()) and (len(self.entries)>1)
	def save(self, *args, **kwargs):
		if 'date' in self.changed_columns():
			for entry in self.entries:
				entry.date=self.date
		self._remove_duplicate_entries()
		if self.validate_entries():
			super(Transaction, self).save()
			self.save_entries()
			return True
		return False
	class Meta:
		get_latest_by = 'date'
		ordering = ('date',)
		verbose_name_plural = _('Transactions')
		verbose_name = _('Transaction')
	def __unicode__(self):
		return str(self.id)+ " - " + str(self.date)
	date = DateTimeField(default=datetime.now(), blank=True)
	
class	Entry(DirtyMixin, Model):	
	date = DateTimeField(default=datetime.now(), blank=True)
	account = ForeignKey(Account)
	value = DecimalField(max_digits=5, decimal_places=2, default='0.00')
	modifier = IntegerField(choices=MODIFIER_CHOICES, default=1)
	transaction = ForeignKey(Transaction)
	def get_parent_accounts(self):
		return [self.account] + self.account.all_parent_accounts()
	parent_accounts=property(get_parent_accounts)
	def get_balance(self, account=None):
		return self.balance_set.get(account=(account or self.account))
	def set_balance(self, value, account=None):
		for account in self.parent_accounts:
			self.balance_set.get(account=account).value=value
	def adjust_transactions(self, account, start, end, value):
		balance=0
		if account.entry_set.filter(date__lt=start).count()>0:
			if start<end:
				##print "value=" + str(value)
				##print "account.entry_set.filter(date__lt=start).latest().balance=" + str(account.entry_set.filter(date__lt=start).latest().balance)
				balance=account.entry_set.filter(date__lt=start).latest().balance + value*account.modifier
			else:
				balance=account.entry_set.filter(date__lt=start).latest().balance
#			#print "balance=" + str(balance)
		for entry in account.entry_set.filter(date__lt=end).filter(date__gt=start):
#			#print "entry=" + str(entry)
#			#print "entry.modifier=" + str(entry.modifier)
#			#print "entry.value=" + str(entry.value)
#			#print "account.modifier=" + str(account.modifier)
#			#print "entry.modifier * entry.value * account.modifier=" + str(entry.modifier * entry.value * account.modifier)
#			#print "balance + entry.modifier * entry.value * account.modifier=" + str(balance + entry.modifier * entry.value * account.modifier)
			entry.balance=balance + entry.modifier * entry.value * account.modifier
			balance=entry.balance
			entry.save()
#			#print "entry=" + str(entry)
	def save(self, *args, **kwargs):
		changes=self.changed_columns()
		update_balance=False
#		##print "pk="+str(self.pk)
#		##print "isnew="+str(self.is_new())
#		##print changes
#		##print "date in changes:" + str('date' in changes)
		
		##############################################################################
		# Account has changed. Well remove all traces of the transacion on the old
		# account, and then treat it like its new
		if 'account_id' in changes and not self.is_new():
			update_balance=True
			old=self._original_state
			old_account=Account.objects.get(pk=old['account_id'])
			# its okay that this code below is repeated, cause if we go through this code 
			# the values will be different later, and if we dont run this code, 
			# well then we'd have to do it later anyway
			old_value=0
			if old['modifier'] and old['value']:
				old_value=old['modifier'] * old['value'] * old_account.modifier
			# Remove trace of this transaction in this account
			for entry in old_account.entry_set.filter(date__gt=old['date']):
				entry.balance -= old_value
				entry.save()
			#From here on out, we want it to be like a new transaction
			changes['modifier']={'new':self.modifier, 'old':None}
			changes['value']={'new':self.value, 'old':None}
#			print changes
			if 'date' in changes:
				del changes['date']
		##############################################################################
		# Date has changed. Well adjust the balances of all transactions between the two dates
#		#print "date in changes:" + str('date' in changes)
		if 'date' in changes:
#			#print "detected change of date"
			update_balance=True
			if changes['date']['old']:
				if changes['date']['old'] > self.date:
	#				#print "Moved back in time"
	#				#print "Were gonna change the following transactions: " + str(self.account.entry_set.filter(date__lt=changes['date']['old']).filter(date__gt=changes['date']['new']))
					self.adjust_transactions(self.account, self.date, changes['date']['old'] , self.value * self.modifier)
				else:
	#				#print "Moved forward in time"
					self.adjust_transactions(self.account, changes['date']['old'], self.date , self.value * self.modifier)
		##############################################################################
		# Now we just have to deal with changes in values and modifiers
		# basicly we get the difference and apply it to balances of all later transactions
		# Theres probably a better way to do this next section:
		if 'modifier' in changes or 'value' in changes:
			#print "changes=" + str(changes)
			update_balance=True
			if 'modifier' in changes:
				old_mod=changes['modifier']['old']
			else:
				old_mod=self.modifier
			if 'value' in changes:
				old_value = (old_mod or 0) * (changes['value']['old'] or 0) * self.account.modifier
			else:
				old_value = (old_mod or 0)  * (self.value or 0) * self.account.modifier

			#print "self.modifier=" + str(self.modifier)
			#print "self.value=" + str(self.value)
			#print "self.account.modifier=" + str(self.account.modifier)
			#print "self.modifier * self.value * self.account.modifier=" + str(self.modifier * self.value * self.account.modifier)
			new_value=self.modifier * self.value * self.account.modifier
			#print "new_value=" + str(new_value)
			#print "old_value=" + str(old_value)
			diff=new_value-old_value
			#print "diff=" + str(diff)
			# now adjust all newer posts by new_value-old_value
			# this could be really slow if its way in the past
			for entry in self.account.entry_set.filter(date__gt=self.date):
				#print "entry=" + str(entry)
				#print "entry.balance=" + str(entry.balance)
				#print "entry.balance+diff=" + str(entry.balance+diff)
				entry.balance+=diff
				entry.save()
		
		# This should be indented out just a bit
		super(Entry, self).save()
		super(DirtyMixin, self).save()
		if self.balance_set.count() == 0:
			for account in self.parent_accounts:
				self.balance_set.add(Balance(account=account, entry=self))
		if update_balance:
			# now we can reliably get our balance
			last=self.account.entry_set.filter(date__lt=self.date)
			self.balance=self.modifier * self.value * self.account.modifier
			if last:
				self.balance+=last.latest().balance
	
	class Meta:
		verbose_name_plural = _('Entries')
		verbose_name = _('Entry')
		get_latest_by = 'date'
		ordering = ('date',)		
	def __unicode__(self):
		return self.get_modifier_display() +" " +  self.account.display + " $" + str(self.value) + " balance-> "+str(self.get_balance().value)
class Balance(Model):
	value = DecimalField(max_digits=5, decimal_places=2, default=None, null=True)
	entry = ForeignKey(Entry)
	account = ForeignKey(Account)
	class Meta:
		verbose_name_plural = _('Balances')
		verbose_name = _('Balance')
class SimpleTransaction(Transaction):
	"""	
	>>> a = Account.objects.create(name="First Account", number='1011', modifier=1)
	>>> a2 = Account.objects.create(name="Second Account", number='2011', modifier=1)
	>>> a3 = Account.objects.create(name="Third Account", number='3011', modifier=-1)
	>>> s=SimpleTransaction.objects.create(credit_account=a,debit_account=a2,value=Decimal("4.54"), date=datetime(2009,6,16))
	"""
	
	def __init__(self, credit_account, debit_account, value, date=datetime.now()):
		super(SimpleTransaction, self).__init__(date=date)
		self.add_entry(credit_account, -value)
		self.add_entry(debit_account, value)

