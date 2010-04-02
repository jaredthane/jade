class AddReportTemplates < ActiveRecord::Migration
  def self.up
  	create_table :report_templates  do |t|
      t.string :name
      t.text :content
  	end
  end

  def self.down
    drop_table :report_templates
  end
end
