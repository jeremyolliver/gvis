############################################
# include this Module in ApplicationHelper #
############################################
module GoogleVisualisation
  
  attr_accessor :google_visualisations, :visualisation_packages
  
  #######################################################################
  # Place these method calls inside the <head> tag in your layout file. #
  #######################################################################
  
  # Include the Visualisation API code from google.
  # (Omit this call if you prefer to include the API in your own js package)
  def include_visualisation_api
    %Q(<!--Load the AJAX API--><script type="text/javascript" src="http://www.google.com/jsapi"></script>)
  end
  
  # This code actually inserts the visualisation data
  def render_visualisations
    if @google_visualisations
      package_list = []
      @visualisation_packages.each do |p|
        package_list << "\'#{p.to_s.camelize.downcase}\'"
      end
      concat %Q(
        <script type="text/javascript">
          google.load('visualization', '1', {'packages':[#{package_list.join(',')}]});
          google.setOnLoadCallback(drawCharts);
          var chartData = {};
          var visualizationCharts = {};
          function drawCharts() { )
            @google_visualisations.each do |id, vis|
              generate_visualisation(id, vis.first, vis.second, vis.third)
            end
      concat("} </script>")
    end
    "<!-- Rendered Google Visualisations /-->"
  end
  
  ########################################################################
  # Call this method from the view to insert the visualisation data here #
  ########################################################################
  def visualization(id, chart_type, options = {}, &block)
    init
    options.stringify_keys!
    @visualisation_packages << chart_type
    table = DataTable.new(options.delete("data"), options.delete("columns"), options)
    if block_given?
      yield table
    end
    html_options = options.delete("html") || {}
    @google_visualisations.merge!(id => [chart_type, table, options])
    html = ""
    html_options.each do |key, value|
      html += %Q(#{key}="#{value}" )
    end
    concat %Q(<div id="#{id}" #{html}><!-- /--></div>)
  end
  
  protected
  
  def init
    @google_visualisations ||= {}
    @visualisation_packages ||=[]
  end
  
  ###################################################
  # Internal methods for building the script data   #
  ###################################################
  def generate_visualisation(id, chart, table, options={})
    # Generate the js chart data
    concat "chartData['#{id}'] = new google.visualization.DataTable();"
    table.columns.each do |col|
      concat "chartData['#{id}'].addColumn('#{table.column_types[col]}', '#{col}');"
    end
    option_str = []
    options.each do |key, val|
      option_str << "#{key}: #{val}"
    end
    concat %Q(
      chartData['#{id}'].addRows(#{data_to_js(table.data,table.column_types)});
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
  
  def data_to_js(data, col_types)
    ds = "["
    data.each do |row|
      rs = "["
      row.each_with_index do |entry,index|
        safe_val = if col_types[index] == "date" || entry.is_a?(Date)
          entry.is_a?(String) ? entry : "new Date (#{entry.year},#{entry.month},#{entry.day})"
        elsif col_types[index] == "datetime" || entry.is_a?(Time)
          entry.is_a?(String) ? entry : "new Date (#{entry.year},#{entry.month},#{entry.day},#{entry.hour},#{entry.min},#{entry.sec})"
        else
          entry.to_json
        end
        rs += safe_val
        rs += (entry == row.last) ? "]" : ","
      end
      ds += rs
      ds += (row == data.last) ? "]" : ","
    end
    ds
  end
  
end