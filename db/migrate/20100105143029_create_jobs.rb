class CreateJobs < ActiveRecord::Migration
  def self.up
  	create_table :jobs do |t|
      t.string :name
      t.time :planned
      t.time :started
      t.time :finished
    end
  end

  def self.down
  	drop_table :jobs
  end
end
