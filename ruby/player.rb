require 'js'

class Player < Point
  class Bullets
    class Bullet < Point
      attr_reader :size, :vector, :type, :color

      def initialize(x, y, size, vector, color, type)
        self.x = x
        self.y = y
        @size = size
        @vector = vector
        @color = color
        @type = type
      end

      def action!
        self.x += vector.x
        self.y += vector.y
      end

      def screen_out?(display_size)
        display_size.x < x || display_size.y < y || x.negative? || (y + size.y).negative?
      end
    end

    attr_reader :player, :bullets

    def initialize(player)
      @player = player
      @bullets = []
    end

    def shot!(x, y, type)
      case type
      when :super
        color = '#7FDFFD'
        size = Point.new(5, 15)
        vector = Point.new(100, 0)
        _y = y - 8
        10.times do |index|
         _x = x + index * 10
          bullets << Bullet.new(_x, _y, size, vector, color, type)
        end
      when :boost
        color = '#8186FF'
        size = Point.new(5, 20)
        vector = Point.new(50, 0)
        _y = y - 10
        5.times do |index|
          _x = x + index * 10
          bullets << Bullet.new(_x, _y, size, vector, color, type)
        end
      when :normal
        color = '#ED82F6'
        size = Point.new(5, 30)
        vector = Point.new(25, 0)
        bullets << Bullet.new(x, y - 45, size, Point.new(25, -15), color, type)
        bullets << Bullet.new(x, y - 15, size, Point.new(25, 0), color, type)
        bullets << Bullet.new(x, y + 15, size, Point.new(25, 15), color, type)
      end
    end

    def action!
      bullets.each(&:action!)
      bullets.reject!{ |bullet| bullet.screen_out?(player.display_size) }
    end

    def each(&block)
      bullets.each(&block)
    end
  end

  attr_reader :max_pos, :image, :size, :bullets, :canvas

  BASE_SPEED = 10.freeze
  IMG_PATH = './img/player.png'.freeze

  # NOTE: image[:width]/image[:height]で取得しようとしたときに稀に0で取得される時があるのでべた書き
  SIZE = 50.freeze

  def initialize(canvas, fps)
    @image = JS.eval('return new Image()')
    @image[:src] = IMG_PATH
    @size = Point.new(SIZE, SIZE)
    @canvas = canvas
    @max_pos = Point.new(display_size.x - size.x, display_size.y - size.y)
    self.x = (max_pos.x * 0.1).to_i
    self.y = (max_pos.y * 0.5).to_i
    @bullets = Bullets.new(self)
    @fps = fps
    @s_counter = 0
  end

  def action!(key)
    type = calc_type(key)
    speed = type == :normal ? BASE_SPEED : BASE_SPEED / 2
    if key.pressed? :up
      self.y -= speed
    end
    if key.pressed? :down
      self.y += speed
    end
    if key.pressed? :left
      self.x -= speed
    end
    if key.pressed? :right
      self.x += speed
    end
    self.x = 0 if x.negative?
    self.y = 0 if y.negative?
    self.x = max_pos.x if x >= max_pos.x
    self.y = max_pos.y if y >= max_pos.y

    bullets.action!
    if key.pressed? :shot
      bullets.shot!(x + SIZE, y + (SIZE / 2), type)
    end
  end

  def display_size
    canvas.display_size
  end

  private

  def calc_type(key)
    boost = key.pressed?(:boost)
    moving = key.pressed?(:up) || key.pressed?(:down) || key.pressed?(:left) || key.pressed?(:right)
    if boost && !moving
      @s_counter += 1
    else
      @s_counter = 0
    end

    # 2secその場に留まるとsuper mode
    if @s_counter > (@fps * 2)
      :super
    elsif boost
      :boost
    else
      :normal
    end
  end
end