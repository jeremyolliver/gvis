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
  
  def register_column(type, name, options = {})
    @columns << name.to_s
    @column_types.merge!(name.to_s => type.to_s)
  end
  
  def add_row(row)
    @data << row
  end
  
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
  
  def js_format_data
    ds = "["
    @data.each do |row|
      rs = "["
      row.each_with_index do |entry,index|
        safe_val = if @column_types[index] == "date" || entry.is_a?(Date)
          entry.is_a?(String) ? entry : "new Date (#{entry.year},#{entry.month},#{entry.day})"
        elsif @column_types[index] == "datetime" || entry.is_a?(Time)
          entry.is_a?(String) ? entry : "new Date (#{entry.year},#{entry.month},#{entry.day},#{entry.hour},#{entry.min},#{entry.sec})"
        else
          entry.to_json
        end
        rs += safe_val
        rs += (index == row.size - 1) ? "]" : ","
      end
      ds += rs
      ds += (row == data.last) ? "]" : ","
    end
    ds
  end
  
  # Class Methods
  class << self
    
    def determine_type(val)
      case val.class
      when String
        "string"
      when Fixnum
        "number"
      when Float
        "number"
      when Date
        "date"
      when Time
        "datetime"
      end
    end
    
  end
  
end