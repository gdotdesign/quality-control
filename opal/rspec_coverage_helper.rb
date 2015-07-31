require 'opal-source-maps'

def simple_coverage(map)
  stats = 0
  hits  = 0
  current = 0

  coverage = Native(`window.__coverage__`)
  coverage.each do |file, value|
    Fron::Request.new("/__OPAL_SOURCE_MAPS__/#{file}.self.map").get do |resp|
      source_map = SourceMap::Map.from_json(resp.body)
      hit_map = {}
      s_map = {}

      statements = Native(value)[map]
      statements.each do |st, count|
        fn = `value.fnMap[#{st}]`
        mapping = source_map.bsearch(SourceMap::Offset.new(`#{fn}.loc.start.line`, `#{fn}.loc.start.column`))
        next unless mapping
        s_map[mapping.original.line] = true
        hit_map[mapping.original.line] = true if count.to_i > 0
      end

      percent = ((hit_map.keys.count / s_map.keys.count) * 100).round
      if percent < 100
        puts "#{file}: #{percent}%\n  Missed: #{(s_map.keys - hit_map.keys)}"
      end

      hits += hit_map.keys.count
      stats += s_map.keys.count
      current += 1

      if current == `Object.keys(window.__coverage__).length`
        puts "\nCoverage: " + ((hits / stats) * 100).round.to_s + '%'
      end
    end
  end
end

::RSpec.configure do |c|
  c.after(:suite)  do
    simple_coverage 'f' if `!!window.__coverage__`
  end
end
