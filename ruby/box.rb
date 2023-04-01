class Box < Point
  class Area
    attr_reader :top, :right, :bottom, :left
    def initialize(x, y, size_x, size_y)
      @left = x
      @top = y
      @right = x + size_x
      @bottom = y + size_y
    end

    # NOTE: シンプルに現在位置同士で衝突を判定し、移動経路上での衝突は見ない
    def hit?(area)
      left <= area.right && right >= area.left && top <= area.bottom && bottom >= area.top
    end
  end

  attr_writer :size
  attr_reader :size
  def initialize(x, y, size_x, size_y)
    super(x, y)
    @size = Point.new(size_x, size_y)
  end

  def collision_area
    if @collision_offset.nil?
      Area.new(x, y, size.x, size.y)
    else
      Area.new(x + @collision_offset.x, y + @collision_offset.y, @collision_offset.size.x, @collision_offset.size.y)
    end
  end

  def collision_offset=(box)
    @collision_offset = box
  end
end