# This DataTable class parses ruby options into the neccesary javascript table sctructure.
# Based off Google's open source Python version (http://code.google.com/apis/visualization/documentation/dev/gviz_api_lib.html)

# Converts Ruby data into data for Google Visualization API clients.
#
# This library can be used to create a google.visualization.DataTable usable by
# visualizations built on the Google Visualization API. Output formats are raw
# JSON, JSON response, and JavaScript.
#
# This ruby wrapper is written by Jeremy Olliver
# adapted from Google's open source Python wrapper (http://code.google.com/apis/visualization/documentation/dev/gviz_api_lib.html)
# which is licensed under version 2.0 of the Apache license http://www.apache.org/licenses/LICENSE-2.0
class DataTable
  
  attr_accessor :data, :columns, :column_types
  
  def initialize(data = nil, columns = [], options = {})
    @columns, @column_types = [], {}
    unless columns.empty?
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