require_relative 'lib/quality_control'
require_relative 'lib/quality_control/rubocop'
require_relative 'lib/quality_control/yard'

QualityControl::Rubocop.directories += %w(lib)
QualityControl::Yard.treshold = 98
QualityControl.tasks += %w(syntax:ruby documentation:coverage)
