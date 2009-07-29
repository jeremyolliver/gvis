############################################
# include this Module in ApplicationHelper #
############################################
module GoogleVisualisation
  
  attr_accessor :google_visualisations
  @google_visualisations = {}
  
  #######################################################################
  # Place these method calls inside the <head> tag in your layout file. #
  #######################################################################
  
  # Include the Visualisation API code from google.
  # (Omit this call if you prefer to include the API in your own js package)
  def include_visualisation_api
    # FIXME, put in correct API url
    # %Q(<script src="http://api.google.com/code..." />)
    ""
  end
  
  # This code actually inserts the visualisation data
  def render_visualisations
    if @google_visualisations
      @google_visualisations.each do |id, vis|
        generate_visualisation(vis.first, vis.second, vis.third)
      end
    end
    "<!-- Rendered Google Visualisations /-->"
  end
  
  ########################################################################
  # Call this method from the view to insert the visualisation data here #
  ########################################################################
  def visualise(id, chart, data, options = {})
    options.symbolize_keys!
    html_options = options.delete(:html)
    @google_visualisations.merge!(id => [chart, data, options])
    %Q(<div id="#{id}" ><!-- /--></div>)
  end
  
  ###################################################
  # Internal methods for handling options correctly #
  ###################################################
  def generate_visualisation(chart, data, options)
    # TODO, write the options parsing etc
    concat("this is a " + chart.inspect)
  end
  
end