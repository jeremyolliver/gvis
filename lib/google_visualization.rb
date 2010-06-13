# Provides calls for simplifying the loading and use of the Google Visualization API
#
# For use with rails, include this Module in ApplicationHelper
# See the Readme for usage details
#
# written by Jeremy Olliver
module GoogleVisualization
  
  attr_accessor :google_visualizations, :visualization_packages
  
  #######################################################################
  # Place these method calls inside the <head> tag in your layout file. #
  #######################################################################
  
  # Include the Visualization API code from google.
  # (Omit this call if you prefer to include the API in your own js package)
  def include_visualization_api
    javascript_include_tag("http://www.google.com/jsapi")
  end
  
  # This code actually inserts the visualization data
  def render_visualizations
    if @google_visualizations
      package_list = []
      @visualization_packages.uniq.each do |p|
        package_list << "\'#{p.to_s.camelize.downcase}\'"
      end
      output = %Q(
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':[#{package_list.uniq.join(',')}]});
          google.setOnLoadCallback(drawCharts);
          var chartData = {};
          var visualizationCharts = {};
          function drawCharts() { )
            @google_visualizations.each do |id, vis|
              output += generate_visualization(id, vis[0], vis[1], vis[2])
            end
      output += "} </script>"
      raw(output + "<!-- Rendered Google Visualizations /-->")
    else
      raw("<!-- No graphs on this page /-->")
    end
  end

  ########################################################################
  # Call this method from the view to insert the visualization data here #
  # Will output a div with given id, and add the chart data to be        #
  # rendered from the head of the page                                   #
  ########################################################################
  def visualization(id, chart_type, options = {}, &block)
    init
    chart_type = chart_type.camelize      # Camelize the chart type, as the Google API follows Camel Case conventions (e.g. ColumnChart, MotionChart)
    options.stringify_keys!               # Ensure consistent hash access
    @visualization_packages << chart_type # Add the chart type to the packages needed to be loaded
    
    # Initialize the data table (with hashed options), and pass it the block for cleaner adding of attributes within the block
    table = DataTable.new(options.delete("data"), options.delete("columns"), options)
    if block_given?
      yield table
    end
    
    # Extract the html options
    html_options = options.delete("html") || {}
    # Add our chart to the list to be rendered in the head tag
    @google_visualizations.merge!(id => [chart_type, table, options])
    
    # Output a div with given id, that our graph will be embedded into
    html = ""
    html_options.each do |key, value|
      html += %Q(#{key}="#{value}" )
    end
    concat raw(%Q(<div id="#{id}" #{html}><!-- /--></div>))
    nil
  end
  
  protected
  
  # Initialize instance variables
  def init
    @google_visualizations ||= {}
    @visualization_packages ||=[]
  end
  
  ###################################################
  # Internal methods for building the script data   #
  ###################################################
  def generate_visualization(id, chart, table, options={})
    # Generate the js chart data
    output = "chartData['#{id}'] = new google.visualization.DataTable();"
    table.columns.each do |col|
      output += "chartData['#{id}'].addColumn('#{table.column_types[col]}', '#{col}');"
    end
    option_str = []
    options.each do |key, val|
      option_str << "#{key}: #{val}"
    end
    output += %Q(
      chartData['#{id}'].addRows(#{table.js_format_data});
      visualizationCharts['#{id}'] = new google.visualization.#{chart.to_s.camelize}(document.getElementById('#{id}'));
      visualizationCharts['#{id}'].draw(chartData['#{id}'], {#{option_str.join(',')}});
    )
  end
  
end