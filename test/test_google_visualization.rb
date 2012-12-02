require 'helper'

class TestGoogleVisualization < MiniTest::Unit::TestCase

  require 'action_view'

  module ApplicationHelper
    include GoogleVisualization
  end

  # Mocking out ActionView
  class MockView
    attr_accessor :buffer
    include ApplicationHelper

    def concat(s)
      @buffer ||= ""
      @buffer << s
    end

    def raw(s)
      s
    end

    def render(template)
      ERB.new(File.read(template)).result(binding)
      # Render the view file first, then the overall layout
      ERB.new(File.read("test/views/layout.html.erb")).result(binding)
    end
  end

  def setup
    @view = MockView.new
  end

  def test_attributes_and_methods
    defined_attributes = [:google_visualizations, :visualization_packages]
    defined_attributes.each do |a|
      assert @view.respond_to?(a), "GoogleVisualization should have defined attribute: #{a}"
    end
    methods = [:include_visualization_api, :render_visualizations, :visualization]
    methods.each do |meth|
      assert @view.respond_to?(meth), "GoogleVisualization should have defined method: ##{meth}"
    end
  end

  def test_support_for_corechart
    output = @view.render("test/views/_corechart.html.erb")
    assert_match("'packages':['corechart']", output, "only the corechart package should have been loaded")
    %w(AreaChart BarChart ColumnChart LineChart PieChart).each do |chart_type|
      assert_match("<div id=\"#{chart_type}_id\"", output, "The #{chart_type} graph div should exist on the page")
    end
  end

  def test_motion_chart
    output = @view.render("test/views/_motionchart.html.erb")
    assert_match("'packages':['motionchart']", output, "the motionchart package should have been loaded")
    assert_match("<div id=\"my_chart\"", output, "The graph div should exist on the page")
  end

  def test_annotated_timeline
    output = @view.render("test/views/_annotatedtimeline.html.erb")
    assert_match("'packages':['annotatedtimeline']", output, "the annotated timeline package should have been loaded")
    assert_match("<div id=\"my_chart\"", output, "The graph div should exist on the page")
    assert_match("zoomStartTime: new Date (2011,0,1)", output, "The a zoomStartTime date option should exist on the page")
    assert_match("thickness: 11", output, "The a thickness number option should exist on the page")
    assert_match("displayZoomButtons: true", output, "The a displayZoomButtons boolean option should exist on the page")
    assert_match("timeofdayTest: [1,2,3,4]", output, "The a timeofDayTest timeofday option should exist on the page")
    assert_match("nullTest: null", output, "The a nullTest null option should exist on the page")
  end

end
