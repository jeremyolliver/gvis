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
  
  def initialize(data, columns = [])
    @columns, @column_types = [], {}
    if !columns.empty?
      columns.each do |type, name|
        @columns << name.to_s
        @column_types.merge!(name.to_s => type.to_s)
      end
    elsif !data.empty?
      row = data.first
      row.each_with_index do |val, index|
        name = "Column #{index + 1}"
        @columns << name
        @column_types.merge!(name => DataTable.determine_type(val))
      end
    else
      raise "Unable to determine column types" # TODO: perhaps a default set should be used
    end
    @data = data
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