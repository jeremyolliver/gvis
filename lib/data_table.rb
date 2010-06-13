# Converts Ruby data structures into javascript strings for constructing the data for Google Visualization API clients.
#
# This library can be used to create a google.visualization.DataTable usable by
# visualizations built on the Google Visualization API. Output formats are raw
# JSON, JSON response, and JavaScript.
#
# written by Jeremy Olliver
class DataTable
  
  attr_accessor :data, :columns, :column_types
  
  def initialize(data = nil, columns = [], options = {})
    @columns, @column_types = [], {}
    unless columns.nil? || columns.empty?
      columns.each do |type, name|
        register_column(type, name, options)
      end
    end
    @data = data || []
  end
  
  # Registers each column explicitly, with data type, and a name associated
  def register_column(type, name, options = {})
    @columns << name.to_s
    @column_types.merge!(name.to_s => type.to_s)
  end
  
  # Adds a single row to the table
  def add_row(row)
    @data << row
  end
  
  # Adds multiple rows (2D array) to the table
  def add_rows(rows)
    @data += rows
  end
  
  # Handle the Column definition methods (#string, #number, #date, #datetime)
  def method_missing(method, *arguments)
    if ["string", "number", "date", "datetime"].include?(method.to_s)
      options = arguments.extract_options!
      register_column(method, arguments, options)
    else
      raise NoMethodError.new(method)
    end
  end
  
  ###################################################################################
  # Format the ruby arrays into JS                                                  #
  # Builds up a string representing a JS Array with JS escaped and formatted values #
  ###################################################################################
  def js_format_data
    formatted_rows = []
    @data.each do |row|
      values = []
      row.each_with_index do |entry,index|
        # Format/escape individual values for javascript, checking column types, and the ruby value as a failsafe
        safe_val = if @column_types[index] == "date" || entry.is_a?(Date)
          # Format a date object as a javascript date
          entry.is_a?(String) ? entry : "new Date (#{entry.year},#{entry.month - 1},#{entry.day})"
        elsif @column_types[index] == "datetime" || entry.is_a?(Time)
          # Format a Time (datetime) as a javascript date object down to seconds
          entry.is_a?(String) ? entry : "new Date (#{entry.year},#{entry.month - 1},#{entry.day},#{entry.hour},#{entry.min},#{entry.sec})"
        else
          # Non date/time values can be JS escaped/formatted safely with # to_json
          entry.to_json
        end
        values << safe_val
      end
      rowstring = "[#{values.join(",")}]"
      formatted_rows << rowstring
    end
    "[#{formatted_rows.join(',')}]"
  end
  
end
