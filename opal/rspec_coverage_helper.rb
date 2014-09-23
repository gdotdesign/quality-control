def simpleCoverage(map)
  fullStats = 0
  fullHits  = 0

  coverage = Native(`window.__coverage__`)
  coverage.each do |file, value|
    stats = 0
    hits  = 0

    statements = Native(value)[map]
    statements.each do |st,count|
      stats += 1
      fullStats += 1
      if count.to_i > 0
        hits += 1
        fullHits += 1
      else
        puts st
        `console.log(JSON.stringify(value.fnMap[#{st}]))`
      end
    end
    percent = ((hits/stats)*100).round
    if percent < 100
      puts "#{file}: " + percent.to_s + "%"
    end
  end
  puts "\nCoverage: " + ((fullHits/fullStats)*100).round.to_s + "%"
end

::RSpec.configure do |c|
  c.after(:suite)  do
    simpleCoverage "f" if `!!window.__coverage__`
  end
end
