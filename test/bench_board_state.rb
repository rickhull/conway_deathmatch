require 'conway_deathmatch'
require 'minitest/benchmark'
require 'minitest/autorun'

include ConwayDeathmatch

describe "Create table" do
  bench_range do
    bench_exp 9, 9999, 3
  end

  bench_performance_linear "width*height", 0.9 do |n|
    BoardState.new(n, n)
  end
end

describe "Board ticks" do
  bench_range do
    bench_exp 1, 100, 3
  end

  bench_performance_linear "acorn demo", 0.9995 do |n|
    b = BoardState.new(70, 40)
    Shapes.add(b, "acorn 50 18")
    n.times { b.tick }
  end
end
