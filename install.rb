# This file is run when the plugin is installed
puts %Q(
Gvis
====

Ruby wrapper for easily loading the Google Visualization API, and simple generation of the javascript required to plot the graphs


Installation
============

script/plugin install git://github.com/jeremyolliver/gvis.git

# Include the GoogleVisualization module in app/helpers/application_helper.rb
module ApplicationHelper
  
  include GoogleVisualization
  
end

# Load the API, and render any graphs by placing these methods inside your layout
# app/views/layouts/application.html.erb
<head>
	<%= include_visualisation_api %>
	<%= render_visualisations %>
...
</head>

see vendor/plugins/gvis/README for usage information

)