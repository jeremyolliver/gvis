Gem::Specification.new do |s|
  s.name        = "gvis"
  s.version     = "1.0.2"
  s.summary     = "Easily embed charts with Google Visualization API"
  s.email       = "jeremy.olliver@gmail.com"
  s.homepage    = "http://github.com/jeremyolliver/gvis"
  s.description = "Easily embed charts with Google Visualization API, using ruby formatted options in your view files"
  s.author      = "Jeremy Olliver"

  s.files = ["README","Rakefile","MIT-LICENSE"]
  s.files += ["lib/gvis.rb", "lib/data_table.rb", "lib/google_visualization.rb"]
  # s.test_files = ["test/gvis_test.rb", "test/test_helper.rb"]
end
