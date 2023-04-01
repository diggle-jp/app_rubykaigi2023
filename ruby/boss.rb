class Boss < Point
  attr_reader :canvas, :size, :color

  X_SIZE = 100.freeze
  def initialize(canvas)
    @canvas = canvas
    @size = Point.new(X_SIZE, (canvas.display_size.y * 0.9).to_i)
    @color = '#003e00'
    self.x = canvas.display_size.x - 100
    self.y = ((canvas.display_size.y - size.y) * 0.5).to_i
  end
end