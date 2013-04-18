Gvis
====

[![Gem Version](https://badge.fury.io/rb/gvis.png)](http://badge.fury.io/rb/gvis) : Latest published version on [rubygems.org](https://rubygems.org/gems/gvis/)

[![Build Status](https://secure.travis-ci.org/jeremyolliver/gvis.png)](http://travis-ci.org/jeremyolliver/gvis) [![Coverage Status](https://coveralls.io/repos/jeremyolliver/gvis/badge.png?branch=master)](https://coveralls.io/r/jeremyolliver/gvis) [![Code Climate](https://codeclimate.com/github/jeremyolliver/gvis.png)](https://codeclimate.com/github/jeremyolliver/gvis) Current master branch status

Rails plugin that provides a Ruby wrapper for easily loading the Google Visualization API, and simple generation of the javascript required to plot the graphs
For a full list of the graphs provided by google's visualization api see the [gallery](http://code.google.com/apis/visualization/documentation/gallery.html)
For documentation on how to use each graph type see google's [API documentation](http://code.google.com/apis/visualization/documentation/)

Compatiblity
------------

gvis version 2.x - Rails 3.x compatible (And rails 2.x using rails_xss)

gvis version 1.x - Rails 2.x compatible


Installation
============

Rails 3:

	# Gemfile
	gem 'gvis', '>= 2.0.0'

Rails 2.X:

	# config/environment.rb
	config.gem 'gvis', :version => '< 2.0.0'

Then include the GoogleVisualization module in app/helpers/application_helper.rb

	module ApplicationHelper
	  include GoogleVisualization
	end

Load the API, and render any graphs by placing these methods inside your layout

	# app/views/layouts/application.html.erb
	<head>
		<%= include_visualization_api %>
		<%= render_visualizations %>
		...
	</head>


Example
=======

Render desired graphs in the view like this:

	# index.html.erb
	<% visualization "my_chart", "MotionChart", :width => 600, :height => 400, :html => {:class => "graph_chart"} do |chart| %>
		<%# Add the columns that the graph will have %>
		<% chart.string "Fruit" %>
		<% chart.date "Date" %>
		<% chart.number "Sales" %>
		<% chart.number "Expenses" %>
		<% chart.string "Location" %>

		<%# Add the data %>
		<% chart.add_rows([
			["Apples", Date.new(1998,1,1), 1000,300,'East'],
			["Oranges", Date.new(1998,1,1), 950,200,'West'],
			["Bananas", Date.new(1998,1,1), 300,250,'West'],
			["Apples", Date.new(1998,2,1), 1200,400,'East'],
			["Oranges", Date.new(1998,2,1), 950,150,'West'],
			["Bananas", Date.new(1998,2,1), 788,617,'West']
		]) %>
	<% end %>


Copyright (c) 2009 [Jeremy Olliver], released under the MIT license
