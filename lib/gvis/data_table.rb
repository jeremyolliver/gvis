# This is an internal class intended for use by the helper methods present in the {GoogleVisualization} class.
#
# Converts Ruby data structures into a string containing a javascript array for use with a google.visualization.DataTable[http://code.google.com/apis/visualization/documentation/reference.html#DataTable] javascript object
#
# @author Jeremy Olliver
module Gvis
  class DataTable

    require 'json'

    COLUMN_TYPES = ["string", "number", "date", "datetime", "timeofday"]

    attr_accessor :data, :table_columns, :column_types

    # @param [Array] data optional param that may contain a 2D Array for specifying the data upon initialization
    # @param [Array] columns optional param for specifying the column structure upon initialization
    # @param [Hash] options optional param of configuration options for the google.visualization.DataTable javascript object
    def initialize(data = nil, columns = [], options = {})
      @table_columns, @column_types = [], {}
      if columns && columns.any?
        columns.each do |name, type|
          register_column(type, name)
        end
      end
      @data = data || []
    end

    # A one liner to set all the columns at once
    # eg: chart.columns = { :signups => "number", :day => "date" }
    # @param [Hash] cols a hash where keys are column names, and values are a string of the column type
    def columns=(cols)
      cols.each do |name, coltype|
        register_column(coltype, name)
      end
    end

    # @return [Array] The columns stored in this table
    def columns
      @table_columns
    end

    # Adds a single row to the table
    # @param [Array] row An array with a single row of data for the table. Should have the same number of entries as there are columns
    def add_row(row)
      size = row.size
      raise ArgumentError.new("Given a row of data with #{size} entries, but there are only #{@table_columns.size} columns in the table") unless size == @table_columns.size
      @data << row
    end

    # Adds multiple rows to the table
    # @param [Array] rows A 2d Array containing multiple rows of data. Each Array should have the same number of entries as the table has columns
    def add_rows(rows)
      sizes = rows.collect {|r| r.size }.uniq
      expected_size = @table_columns.size
      errors = sizes.select {|s| s != expected_size }
      raise ArgumentError.new("Given a row of data with #{errors.to_sentence} entries, but there are only #{expected_size} columns in the table") if errors.any?
      @data += rows
    end

    # Handle the Column definition methods (#string, #number, #date, #datetime)
    # This allows columns to be defined one at a time, with a dsl similar to AR migrations
    # e.g. table.string "name"
    COLUMN_TYPES.each do |col_type|
      define_method(col_type) do |args|
        register_column(col_type, *args)
      end
    end

    # Outputs the data within this table as a javascript array ready for use by google.visualization.DataTable
    # This is where conversions of ruby date objects to javascript Date objects and escaping strings, and formatting options is done
    # @return [String] a javascript array with the first row defining the table, and subsequent rows holding the table's data
    def format_data
      formatted_rows = []
      @data.each do |row|
        values = []
        row.each_with_index do |entry,index|
          values << Gvis::DataCell.new(entry, @column_types.to_a[index][1]).to_js
        end
        rowstring = "[#{values.join(", ")}]"
        formatted_rows << rowstring
      end
      "[#{formatted_rows.join(', ')}]"
    end
    alias :js_format_data :format_data # For backwards compatibility, just in case
    alias :to_s :format_data

    private

    # Registers each column explicitly, with data type, and a name associated
    # @param [String] type the type of data column being registered, valid input here are entries from DataTable::COLUMN_TYPES
    # @param [String] name the column name that will be used as a label on the graph
    def register_column(type, name)
      type = type.to_s.downcase
      raise ArgumentError.new("invalid column type #{type}, permitted types are #{COLUMN_TYPES.join(', ')}") unless COLUMN_TYPES.include?(type)
      @table_columns << name.to_s
      @column_types.merge!(name.to_s => type)
    end
  
  end
end
