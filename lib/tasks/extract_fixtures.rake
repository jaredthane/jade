task :extract_fixtures => :environment do
  sql = "SELECT * FROM `%s`"
  skip_tables = ["schema_info", "sessions"]
  ActiveRecord::Base.establish_connection
  tables = ENV['FIXTURES'] ? ENV['FIXTURES'].split(/,/) : ActiveRecord::Base.connection.tables - skip_tables
  tables.each do |table_name|
    i = "000"
    File.open("#{RAILS_ROOT}/db/#{table_name}.yml", 'w') do |file|
    	puts "getting: " + sql % table_name
      data = ActiveRecord::Base.connection.select_all(sql % table_name)
      file.write data.inject({}) { |hash, record|
        hash["#{table_name}_#{i.succ!}"] = record
        hash
      }.to_yaml
    end
  end
end



