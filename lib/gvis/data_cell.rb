# This is an internal class intended for use by the helper methods present in the {GoogleVisualization} class.
#
# Converts a Ruby object into a string containing valid javascript for 'string' 'number' 'boolean' 'date' 'datetime' 'timeofday' types
# http://code.google.com/apis/chart/interactive/docs/reference.html#DataTable_getValue
#
# @author Jeremy Olliver
module Gvis
  class DataCell
    attr_accessor :value
    attr_accessor :type

    def initialize(value, type = '')
      @value = value
      @type = type
    end

    def to_js
      # Format/escape individual values for javascript, checking column types, and the ruby value as a failsafe
      if @type == "datetime" || @value.is_a?(DateTime)
        # Format a DateTime as a javascript date object down to seconds
        @value.is_a?(DateTime) ? "new Date (#{@value.year},#{@value.month - 1},#{@value.day},#{@value.hour},#{@value.min},#{@value.sec})" : @value.to_json
      elsif @type == "date" || @value.is_a?(Date)
        # Format a Date object as a javascript date
        @value.is_a?(Date) ? "new Date (#{@value.year},#{@value.month - 1},#{@value.day})" : @value.to_json
      elsif @type == "timeofday" || @value.is_a?(Time)
        # Format a Time as a javascript date object down to milliseconds
        @value.is_a?(Time) ? "[#{@value.hour},#{@value.min},#{@value.sec},#{@value.usec}]" : @value.to_json
      else
        # Non date/time values can be JS escaped/formatted safely with # to_json
        @value.to_json
      end
    end

    def to_s
      @value.to_s
    end
  end
end
