require File.expand_path("../lib/quality_control/version", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'quality_control'
  gem.version = QualityControl::VERSION
  gem.date    = Date.today.to_s

  gem.summary = "Quality Control"
  gem.description = "A gem for running CI tasks like a boss."
  gem.files = `git ls-files`.split($RS)

  gem.authors  = ['Szikszai Gusztáv']
  gem.email    = 'cyber.gusztav@gmail.com'
  gem.homepage = 'https://github.com/gdotdesign/quality-control'

  gem.add_runtime_dependency('rake')
  gem.add_runtime_dependency('opal-rspec', '0.3.0.beta3')
  gem.add_runtime_dependency('rubocop')
  gem.add_runtime_dependency('rubycritic')
  gem.add_runtime_dependency('colorize', '~> 0.7.3')
  gem.add_runtime_dependency('scss-lint')
  gem.add_runtime_dependency('yard')
end
