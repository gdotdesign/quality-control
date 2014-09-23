Quality Control
===============
[![Build Status](https://travis-ci.org/gdotdesign/quality-control.svg?branch=master)](https://travis-ci.org/gdotdesign/quality-control)
[![Code Climate](https://codeclimate.com/github/gdotdesign/quality-control/badges/gpa.svg)](https://codeclimate.com/github/gdotdesign/quality-control)
[![Test Coverage](https://codeclimate.com/github/gdotdesign/quality-control/badges/coverage.svg)](https://codeclimate.com/github/gdotdesign/quality-control)

Quality Control is a ruby gem that unifies **continous integration tasks** (linting, test running, coverage reporting) into reusable **rake tasks**, currently supports the following [plugins.](#plugins)

## Quick Setup
Just add it to your gem file:
```
gem 'quality_control'
```

Then in your **Rakefile** require it and other plugins that you need:
```
require 'quality_control'
require 'quality_control/rubocop'
require 'quality_control/yard'
```

Then configure gem and the plugins:
```
QualityControl::Rubocop.directories += %w(lib)
QualityControl::Yard.treshold = 98
QualityControl.tasks += %w(syntax:ruby documentation:coverage)
```

## Plugins
### RuboCop
This plugin provides **Ruby** language linting via [RuboCop](https://github.com/bbatsov/rubocop):
```
require 'quality_control/rubocop'

# The directories to run rubocop on.
QualityControl::Rubocop.directories += %w(lib)
```
Provies the task `syntax:ruby`

### SCSS 
This plugin provides **SCSS** language linting via [SCSS-Lint](https://github.com/causes/scss-lint):
```
require 'quality_control/scss'

# The directories to run scss-lint on.
QualityControl::SCSS.directories += %w(lib)
```
Provies the task `syntax:scss`

### YARD
This plugin provides **documentation coverage** test via [YARD]():
```
require 'quality_control/yard'

# The threshold for the coverage in percentage
QualityControl::Yard.threshold = 98
```
Provides tasks `documentation:generate` and `documentation:coverage`

### Opal RSpec
This plugin provides **test coverage** for frontend Ruby files via [Opal]() and [Opal RSpec]():
```
require 'quality_control/opal_rspec'

# Regexp to match the files need to be covered.
QualityControl::OpalRspec.files = /^source.*\.rb/

# The threshold for the coverage in percentage
QualityControl::OpalRspec.threshold = 90
```
Then you will need to add the following to your `spec_helper.rb` or similar file:
```
require 'rspec_coverage_helper'
```
Provides tasks **opal:rspec** and **opal:rspec:coverage**.
