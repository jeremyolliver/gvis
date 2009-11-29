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
  
  # Include the Visualisation API code from google.
  # (Omit this call if you prefer to include the API in your own js package)
  def include_visualization_api
    %Q(<!--Load the AJAX API--><script type="text/javascript" src="http://www.google.com/jsapi"></script>)
  end
  
  # This code actually inserts the visualization data
  def render_visualizations
    if @google_visualizations
      package_list = []
      @visualization_packages.each do |p|
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
      output + "<!-- Rendered Google Visualisations /-->"
    end
  end

  ########################################################################
  # Call this method from the view to insert the visualization data here #
  ########################################################################
  def visualization(id, chart_type, options = {}, &block)
    init
    chart_type = chart_type.camelize
    options.stringify_keys!
    @visualization_packages << chart_type
    table = DataTable.new(options.delete("data"), options.delete("columns"), options)
    if block_given?
      yield table
    end
    html_options = options.delete("html") || {}
    @google_visualizations.merge!(id => [chart_type, table, options])
    html = ""
    html_options.each do |key, value|
      html += %Q(#{key}="#{value}" )
    end
    concat %Q(<div id="#{id}" #{html}><!-- /--></div>), block.binding
  end
  
  protected
  
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
  
  def col_type(data)
    case data.class
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