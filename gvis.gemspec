Gem::Specification.new do |s|
  s.name        = "gvis"
  s.version     = "2.0.1"
  s.platform    = Gem::Platform::RUBY
  s.author      = "Jeremy Olliver"
  s.email       = "jeremy.olliver@gmail.com"
  s.homepage    = "http://github.com/jeremyolliver/gvis"
  s.summary     = "Easily embed charts with Google Visualization API"
  s.description = "Easily embed charts with Google Visualization API, using ruby formatted options in your view files"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rcov'
end
