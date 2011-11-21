require 'helper'

class TestDataTable < MiniTest::Unit::TestCase

  def setup
    @table = Gvis::DataTable.new
  end

  def test_attributes_methods_and_constants
    assert defined?(Gvis::DataTable::COLUMN_TYPES)
    assert_equal ["string", "number", "date", "datetime", "timeofday"], Gvis::DataTable::COLUMN_TYPES
    defined_attributes = [:data, :table_columns, :column_types]
    defined_attributes.each do |a|
      assert @table.respond_to?(a), "DataTable should have attribute #{a} defined"
    end
    methods = [:columns, :columns=, :add_row, :add_rows, :format_data] + Gvis::DataTable::COLUMN_TYPES
    methods.each do |meth|
      assert @table.respond_to?(meth), "DataTable should respond to instance method ##{meth}"
    end
  end

  def test_defining_columns
    @table.string "Name"
    @table.number "age"
    @table.date "dob"
    @table.datetime "deceased_at"
    assert_equal 4, @table.columns.size
    assert_equal({"Name" => "string", "age" => "number", "dob" => "date", "deceased_at" => "datetime"}, @table.column_types)
  end

  def test_single_assign_columns
    # should be case insensitive on column types
    @table.columns = [["Name", "String"], ["Surname", "string"], ["age", "number"]]
    assert_equal 3, @table.columns.size
    assert_equal({"Name" => "string", "Surname" => "string", "age" => "number"}, @table.column_types)
  end

  def test_initializing_with_columns
    table = Gvis::DataTable.new(nil, [["Name", "String"], ["Surname", "string"], ["age", "number"]])
    assert_equal 3, table.columns.size
    assert_equal({"Name" => "string", "Surname" => "string", "age" => "number"}, table.column_types)
  end

  def test_adding_rows
    @table.columns = [["Name", "String"], ["Surname", "string"], ["age", "number"]]
    @table.add_row(["Jeremy", "Olliver", 23])
    @table.add_rows([
      ["Optimus", "Prime", 1000],
      ["Mega", "Tron", 999]
    ])
    assert_equal [["Jeremy", "Olliver", 23], ["Optimus", "Prime", 1000], ["Mega", "Tron", 999]], @table.data
  end

  def test_formatting_data
    @table.columns = [["Name", "String"], ["age", "number"], ["dob", "date"], ["now", "datetime"], ["time", "timeofday"]]
    now_datetime = DateTime.new(2011,1,23,11,30,4)
    now_time = Time.utc(2011,01,23,02,45,43,21)
    @table.add_rows([["Jeremy Olliver", 23, Date.new(2011,1,1), now_datetime, now_time], ["Optimus Prime", 1000, Date.new(1980,2,23), now_datetime, now_time], ["'The MegaTron'", 999, Date.new(1981,1,1), now_datetime, now_time]])

    assert_equal %q([["Jeremy Olliver", 23, new Date (2011,0,1), new Date (2011,0,23,11,30,4), [2,45,43,21]], ["Optimus Prime", 1000, new Date (1980,1,23), new Date (2011,0,23,11,30,4), [2,45,43,21]], ["'The MegaTron'", 999, new Date (1981,0,1), new Date (2011,0,23,11,30,4), [2,45,43,21]]]), @table.format_data
  end

end
