# Provides support for formatting display via google.visualization.formatters[http://code.google.com/apis/chart/interactive/docs/reference.html#formatters]
# all formatters except for PatternFormat are currently unsupported
#
# @author Jeremy Olliver
module Gvis
  class Formatter
    FORMATTERS = {
      :ArrowFormat => ['number'],
      :BarFormat => ['number'],
      :ColorFormat => ['number'],
      :DateFormat => ['date', 'datetime'],
      :NumberFormat => ['number']
    }
    attr_accessor :formatter_name, :column, :options

    def initialize(formatter_name, column, options = {})
      @formatter_name = formatter_name.to_sym
      @column = column || :all
      @options = options
    end

    # @param [Array] 2D Array, elements are an array, with first value being column names, second values are the column types
    def render(data_var, columns)
      formatter_string = case @formatter_name
      when :ColorFormat
        str = "var formatter = new google.visualization.#{@formatter_name}();"
        str + @options.collect do |invocation|
          "formatter.#{invocation};"
        end
      else
        "var formatter = new google.visualization.#{@formatter_name}(#{@options.to_json});"
      end
      applicable_columns(columns).each do |index|
        formatter_string += "formatter.format(#{data_var}, #{index});"
      end
      formatter_string
    end

    private

    def applicable_columns(columns)
      case @column
      when :all
        indexes = []
        columns.each_with_index do |column, index|
          indexes << index if can_be_applied?(column[1])
        end
        indexes
      else
        [columns.index(@column)]
      end
    end

    def can_be_applied?(column_type)
      allowed_columns = FORMATTERS[@formatter_name]
      allowed_columns && allowed_columns.include?(column_type)
    end

  end
end
