require_relative 'lib/quality_control'
require_relative 'lib/quality_control/rubocop'
require_relative 'lib/quality_control/rubycritic'
require_relative 'lib/quality_control/yard'

QualityControl::Rubocop.directories += %w(lib)
QualityControl::Rubycritic.directories += %w(lib)
QualityControl::Yard.threshold = 98
QualityControl.tasks += %w(syntax:ruby documentation:coverage rubycritic:coverage)
