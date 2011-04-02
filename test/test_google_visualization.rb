require 'helper'

class TestGoogleVisualization < MiniTest::Unit::TestCase

  class MyApplicationHelper
    include GoogleVisualization
  end

  def setup
    @viz_helper = MyApplicationHelper.new
  end

  def test_attributes_and_methods
    defined_attributes = [:google_visualizations, :visualization_packages]
    defined_attributes.each do |a|
      assert @viz_helper.respond_to?(a), "GoogleVisualization should have defined attribute: #{a}"
    end
    methods = [:include_visualization_api, :render_visualizations, :visualization]
    methods.each do |meth|
      assert @viz_helper.respond_to?(meth), "GoogleVisualization should have defined method: ##{meth}"
    end
  end

end
