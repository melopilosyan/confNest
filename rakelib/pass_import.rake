# frozen_string_literal: true

require "csv"
require "open3"

# Reads a CSV file with passwords & imports into the password store of the pass utility.
# See the extract method for CSV columns usage.
module Pass
  def self.import(csv_path, last_header_name)
    extract(csv_path, last_header_name).each do |name, passwords|
      next pass_add(name, passwords.first) if passwords.size == 1

      passwords.each do |pass|
        pass_add "#{name}/#{pass.first}", pass
      end
    end
  end

  def self.extract(csv_path, last_header_name)
    data = Hash.new { |h, k| h[k] = [] }

    CSV.foreach(csv_path) do |row|
      next if row.last == last_header_name

      name, _url, login, pass = row
      name = name.delete_prefix("http://").delete_prefix("www.").strip

      data[name] << [login, pass]
    end

    data
  end
  private_class_method :extract

  def self.pass_add(path, lp_pair)
    puts "Saving #{path} ..."
    content = "#{lp_pair.last}\nlogin: #{lp_pair.first}\n"

    out, err, status = Open3.capture3("pass add -m '#{path}'", stdin_data: content)

    puts "STDOUT: #{out}STDERR: #{err}" unless status.success?
  end
  private_class_method :pass_add
end

desc "Import passwords from given CSV into the pass utility"
task :pass_import, %i[csv_path last_header_name] do |_, args|
  csv_path = args.csv_path && Pathname.new(args.csv_path).expand_path
  unless csv_path&.exist?
    puts "csv_path is required\n\nUsage:\n  rake pass_import[path/to/passwords.csv]"
    next
  end

  Pass.import(csv_path, args.last_header_name || "note")
end
