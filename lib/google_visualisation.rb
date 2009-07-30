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
  def visualise(id, chart, data, options = {})
    options.symbolize_keys!
    html_options = options.delete(:html)
    @google_visualisations ||= {}
    @visualisation_packages ||=[]
    @visualisation_packages << chart
    @google_visualisations.merge!(id => [chart, data, options])
    %Q(<div id="#{id}" ><!-- /--></div>)
  end
  
  protected
  
  ###################################################
  # Internal methods for building the script data   #
  ###################################################
  def generate_visualisation(id, chart, data, options)
    # Generate the js chart data
    size_options = []
    size_options << "width: #{options[:width].to_i}" if options[:width]
    size_options << "height: #{options[:height].to_i}" if options[:height]
    concat "chartData['#{id}'] = new google.visualization.DataTable();"
    # TODO: how to make this work when columns not explic
    if options[:columns]
      options[:columns].each do |col,name|
        concat "chartData['#{id}'].addColumn('#{kind}', '#{name}');"
      end
    end
    concat %Q(
      chartData['#{id}'].addRows(#{to_js_table(data)});
      visualizationCharts['#{id}'] = new google.visualization.#{chart.to_s.camelize}(document.getElementById('#{id}'));
      visualizationCharts['#{id}'].draw(chartData['#{id}'], {#{size_options.join(',')}});
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
  
  # Recursive data parsing to js format. Mostly the same as to_json, but altered to support Google API specific date and datetime options
  def to_js_table(data, options = {})
    case data.class
    when String || Fixnum || Float
      data.to_json
    when Date
      "new Date (#{data.year},#{data.month},#{data.day})"
    when Time
      "new Date (#{data.year}, #{data,month},#{data.day}, #{data.hour}, #{data.min}, #{data.sec})"
    when Array
      contents = data.each {|el| to_js_table(el) }
      "[#{contents.join(',')}]"
    when Hash
      contents = data.each {|key,val| to_js_table(key) + ": " + to_js_table(val) }
      "{#{contents.join(',')}}"
    else
      data.to_json
    end
  end
  
end