class AddBackgroundsToTemplates < ActiveRecord::Migration
  def self.up
    add_column :report_templates, :background_id, :integer
    add_column :report_templates, :background_content_type, :string
    add_column :report_templates, :background_file_name, :string
    add_column :report_templates, :background_file_size, :integer
  end

  def self.down
    remove_column :report_templates, :background_id
    remove_column :report_templates, :background_content_type
    remove_column :report_templates, :background_file_name
    remove_column :report_templates, :background_file_size
  end
end
