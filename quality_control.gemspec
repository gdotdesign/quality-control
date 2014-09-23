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

  gem.add_dependency('rake')
  gem.add_dependency('opal-rspec', '0.3.0.beta3')
  gem.add_dependency('rubocop', '~> 0.25.0')
  gem.add_dependency('rubycritic', '~> 1.1.1')
  gem.add_dependency('colorize', '~> 0.7.3')
  gem.add_dependency('scss-lint', '~> 0.24.1')
  gem.add_dependency('yard', '~> 0.8.7.4')
end
