class Player
  attr_writer :pos
  attr_reader :pos, :max

  SIZE = 10.freeze

  def initialize(max_x, max_y)
    @max = Point.new(max_x, max_y)
    @pos = Point.new(max.x * 0.5, max.y * 0.9)
  end

  def move!(offset)
    pos.x += offset.x
    pos.y += offset.y
    pos.x = 0 if pos.x.negative?
    pos.y = 0 if pos.y.negative?
    pos.x = max.x if pos.x + SIZE >= max.x
    pos.y = max.y if pos.y + SIZE >= max.y
  end

  def x
    pos.x
  end

  def y
    pos.y
  end
end