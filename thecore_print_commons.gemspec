$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "thecore_print_commons/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "thecore_print_commons"
  s.version     = ThecorePrintCommons::VERSION
  s.authors     = ["Gabriele Tassoni"]
  s.email       = ["gabriele.tassoni@gmail.com"]
  s.homepage = 'https://github.com/gabrieletassoni/thecore' #    = "TODO"
  s.summary = 'Thecorized thecore_print_commons' #     = "TODO: Summary of ThecorePrintCommons."
  s.description = 'Thecorized thecore_print_commons full description.' # = "TODO: Description of ThecorePrintCommons."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  # s.add_dependency "rails", "~> 5.2.1"
    s.add_dependency 'thecore', '~> 1.4'
end
