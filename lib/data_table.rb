# Converts Ruby data structures into javascript strings for constructing the data for Google Visualization API clients.
#
# This library can be used to create a google.visualization.DataTable usable by
# visualizations built on the Google Visualization API. Output formats are raw
# JSON, JSON response, and JavaScript.
#
# This ruby wrapper is written by Jeremy Olliver
class DataTable
  
  attr_accessor :data, :columns, :column_types
  
  def initialize(data = nil, columns = [], options = {})
    @columns, @column_types = [], {}
    unless columns.nil? || columns.empty?
      columns.each do |type, name|
        @columns << name.to_s
        @column_types.merge!(name.to_s => type.to_s)
      end
    end
    @data = data
  end
  
  def register_column(type, name, options = {})
    @columns << name.to_s
    @column_types.merge!(name.to_s => type.to_s)
  end
  
  def method_missing(method, *arguments)
    if ["string", "number", "date", "datetime"].include?(method.to_s)
      options = arguments.extract_options!
      register_column(method, arguments, options)
    else
      raise NoMethodError.new(method)
    end
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