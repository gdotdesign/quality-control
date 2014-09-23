Quality Control
===============
[![Build Status](https://travis-ci.org/gdotdesign/quality-control.svg?branch=master)](https://travis-ci.org/gdotdesign/quality-control)
[![Code Climate](https://codeclimate.com/github/gdotdesign/quality-control/badges/gpa.svg)](https://codeclimate.com/github/gdotdesign/quality-control)
[![Test Coverage](https://codeclimate.com/github/gdotdesign/quality-control/badges/coverage.svg)](https://codeclimate.com/github/gdotdesign/quality-control)

Quality Control is a ruby gem that unifies Continous Integration tasks (linting, test running, coverage reporting) into the same format, currently supports the following [plugins.](#plugins)

## Quick Setup
Just add it to your gem file:
```
gem 'quality_control'
```

Then require it and other plugins that you need:
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
