# Jade Inventory Control System
#Copyright (C) 2009  Jared T. Martin

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.

#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied account of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.


class SalesRepresentativesController < ApplicationController
	def index
		@reps=[]
		@from=(params[:from] ||Date.today)
  	@till=(params[:till] ||Date.today)
		for r in User.find(:all)
			logger.debug 'heres a user' + r.login + " - " + r.clients.length.to_s
			if r.clients.length>0
				rep={:user=>r, :previous_balance=>0, :num_receipts=>0, :revenue=>0, :num_payments=>0, :cash_received=>0, :final_balance=>0}
				rep[:num_receipts] = Receipt.count(:all, 
										:conditions => ['clients.user_id=:rep_id AND date(receipts.created_at) >=:from AND date(receipts.created_at) <= :till', {:from=>@from.to_date.to_s('%Y-%m-%d'), :till=>@till.to_date.to_s('%Y-%m-%d'), :rep_id=>rep[:user].id}],
										:joins=>'inner join orders on orders.id=receipts.order_id inner join entities as clients on clients.id=orders.client_id')
				revenue_posts = Post.find(:all, 
						:conditions=> ['date(trans.created_at) >=:from AND date(trans.created_at) <= :till AND posts.account_id=:account', {:from=>@from.to_date.to_s('%Y-%m-%d'), :till=>@till.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].revenue_account_id}],
						:joins=>'inner join trans on trans.id=posts.trans_id')
				rep[:revenue]=revenue_posts.inject(0) { |result, element| result + element.value*element.post_type_id}.to_s
				rep[:num_payments] = Payment.count(:all, 
										:conditions=> ['clients.user_id=:rep_id AND date(payments.created_at) >=:from AND date(payments.created_at) <= :till', {:from=>@from.to_date.to_s('%Y-%m-%d'), :till=>@till.to_date.to_s('%Y-%m-%d'), :rep_id=>rep[:user].id}],
										:joins=>'inner join orders on orders.id=payments.order_id inner join entities as clients on clients.id=orders.client_id')
				rep[:cash_received] = Post.find(:all, 
						:conditions=> ['date(trans.created_at) >=:from AND date(trans.created_at) <= :till AND posts.account_id=:account', {:from=>@from.to_date.to_s('%Y-%m-%d'), :till=>@till.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].cash_account_id}],
						:joins=>'inner join trans on trans.id=posts.trans_id'
					).collect(&:value).sum
				new_cash_balance, new_rev_balance, old_cash_balance, old_rev_balance=nil, nil, nil, nil
				if r.cash_account
					new_cash_balance=r.cash_account.balance
					last_cash_post=Post.last(:conditions=> ['date(trans.created_at) < :from AND posts.account_id=:account', {:from=>@from.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].cash_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id')
					old_cash_balance=last_cash_post.balance if last_cash_post
				end
				if r.revenue_account
					new_rev_balance=r.revenue_account.balance
					last_rev_post=Post.last(:conditions=> ['date(trans.created_at) < :from AND posts.account_id=:account', {:from=>@from.to_date.to_s('%Y-%m-%d'), :account=>rep[:user].revenue_account_id}],:joins=>'inner join trans on trans.id=posts.trans_id')
					old_rev_balance=last_rev_post.balance if last_rev_post
				end
				rep[:final_balance]=(new_cash_balance||0) - (new_rev_balance||0)
				rep[:previous_balance]=(old_cash_balance||0) - (old_rev_balance||0)
				@reps << rep
			end
		end
		respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reps }
    end
  end

	def report

	end
end
