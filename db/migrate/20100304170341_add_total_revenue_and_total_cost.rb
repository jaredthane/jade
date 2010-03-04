class AddTotalRevenueAndTotalCost < ActiveRecord::Migration
  def self.up
    for line in Line.all()
      if !line.cost
        line.cost = line.product.cost(line.order.client) if line.order_type_id == Order::COUNT
        line.cost = line.product.cost(line.order.client) if line.order_type_id == Order::PURCHASE
        line.cost = line.product.cost(line.order.vendor) if line.order_type_id == Order::SALE        
        line.send(:update_without_callbacks)
      end
    end
    add_column :orders, :total_revenue, :decimal, :precision => 8, :scale => 2
    add_column :orders, :total_expense, :decimal, :precision => 8, :scale => 2
    for order in Order.all()
      order.total_expense = order.total_cost
      order.total_revenue = order.total_price - order.total_expense
      order.send(:update_without_callbacks)
    end
  end

  def self.down
    remove_column :orders, :total_revenue
    remove_column :orders, :total_expense
  end
end
