require 'js'

class Player < Box
  class Bullets
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
          bullets << Bullet.new(_x, _y, size, vector, color)
        end
      when :boost
        color = '#8186FF'
        size = Point.new(5, 20)
        vector = Point.new(50, 0)
        _y = y - 10
        5.times do |index|
          _x = x + index * 10
          bullets << Bullet.new(_x, _y, size, vector, color)
        end
      when :normal
        color = '#ED82F6'
        size = Point.new(5, 30)
        vector = Point.new(25, 0)
        bullets << Bullet.new(x, y - 45, size, Point.new(25, -15), color)
        bullets << Bullet.new(x, y - 15, size, Point.new(25, 0), color)
        bullets << Bullet.new(x, y + 15, size, Point.new(25, 15), color)
      end
    end

    def action!
      bullets.each { |bullet| bullet.action!(player.display_size) }
    end

    def reject_killed!
      bullets.reject!(&:killed)
    end

    def each(&block)
      bullets.each(&block)
    end
  end

  attr_reader :max_pos, :image, :bullets, :canvas, :killed

  BASE_SPEED = 10.freeze
  IMG_PATH = './img/player.png'.freeze

  # NOTE: image[:width]/image[:height]で取得しようとしたときに稀に0で取得される時があるのでべた書き
  SIZE = 50.freeze

  def initialize(canvas)
    @image = JS.eval('return new Image()')
    @image[:src] = IMG_PATH
    @canvas = canvas

    self.size = Point.new(SIZE, SIZE)
    @max_pos = Point.new(display_size.x - size.x, display_size.y - size.y)
    self.x = (max_pos.x * 0.1).to_i
    self.y = (max_pos.y * 0.5).to_i

    # 当たり判定は小さめに
    self.collision_offset = Box.new(0, (SIZE * 0.4).to_i, (SIZE * 0.2).to_i, (SIZE * 0.2).to_i)

    @bullets = Bullets.new(self)
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

  def reject_killed!
    bullets.reject_killed!
  end

  def display_size
    canvas.display_size
  end

  def hit!
    @killed = true
  end

  private

  def calc_type(key)
    boost = key.pressed?(:boost)
    moving = key.pressed?(:up) || key.pressed?(:down) || key.pressed?(:left) || key.pressed?(:right)
    if !moving
      @s_counter += 1
    else
      @s_counter = 0
    end

    # 2secその場に留まるとsuper mode
    if boost
      if @s_counter > canvas.fps
        :super
      else
        :boost
      end
    else
      :normal
    end
  end
end