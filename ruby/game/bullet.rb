class Bullet < Box
  attr_reader :vector, :color, :killed, :is_killer

  def initialize(x, y, size, vector, color, collision_offset: nil)
    self.x = x
    self.y = y
    self.size = size
    @vector = vector
    @color = color
    @collision_offset = collision_offset
    @killed = false
    @is_killer = false
  end

  def action!(display_size)
    self.x += vector.x
    self.y += vector.y
    @killed = display_size.x < x || display_size.y < y || x.negative? || (y + size.y).negative?
  end

  def hit!
    @is_killer = true
  end
end
