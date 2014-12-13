require 'minitest/autorun'
require 'minitest/benchmark'

require 'conway_deathmatch'

include ConwayDeathmatch

BENCH_NEW_THRESH = (ENV['BENCH_NEW_THRESH'] || 0.9).to_f
BENCH_TICK_THRESH = (ENV['BENCH_TICK_THRESH'] || 0.9995).to_f

describe "BoardState.new Benchmark" do
  bench_range do
    bench_exp 9, 9999, 3
  end

  bench_performance_linear "width*height", BENCH_NEW_THRESH do |n|
    BoardState.new(n, n)
  end
end

describe "BoardState#tick Benchmark" do
  bench_range do
    bench_exp 1, 100, 3
  end

  bench_performance_linear "acorn demo", BENCH_TICK_THRESH do |n|
    b = BoardState.new(70, 40)
    Shapes.add(b, "acorn 50 18")
    n.times { b.tick }
  end

  bench_performance_linear "aggressive deathmatch demo",
                           BENCH_TICK_THRESH do |n|
    b = BoardState.new(70, 40)
    b.deathmatch = :aggressive
    Shapes.add(b, "acorn 30 30", "1")
    Shapes.add(b, "diehard 20 10", "2")
    n.times { b.tick }
  end

  bench_performance_linear "defensive deathmatch demo",
                           BENCH_TICK_THRESH do |n|
    b = BoardState.new(70, 40)
    b.deathmatch = :defensive
    Shapes.add(b, "acorn 30 30", "1")
    Shapes.add(b, "diehard 20 10", "2")
    n.times { b.tick }
  end

  bench_performance_linear "friendly deathmatch demo",
                           BENCH_TICK_THRESH do |n|
    b = BoardState.new(70, 40)
    b.deathmatch = :friendly
    Shapes.add(b, "acorn 30 30", "1")
    Shapes.add(b, "diehard 20 10", "2")
    n.times { b.tick }
  end
end
