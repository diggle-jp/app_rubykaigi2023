require 'js'

class Player < Point
  class Bullets
    class Bullet < Point
      attr_reader :type, :color

      def initialize(x, y, boost)
        super(x, y)
        if boost
          @type = :boost
          @color = '#ED82F6'
        else
          @type = :normal
          @color = '#8186FF'
        end
      end

      def action!
        self.x += case type
                  when :boost
                    50
                  when :normal
                    50
                  end
      end

      def screen_out?(display_size)
        display_size.x < x
      end
    end

    attr_reader :player, :bullets

    def initialize(player)
      @player = player
      @bullets = []
    end

    def shot!(x, y, boost)
      bullets << Bullet.new(x, y, boost)
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

  MOVE_PER_FLAME = 5.freeze
  IMG_PATH = './img/player.png'.freeze

  # NOTE: image[:width]/image[:height]で取得しようとしたときに稀に0で取得される時があるのでべた書き
  SIZE = 50.freeze

  def initialize(canvas)
    @image = JS.eval('return new Image()')
    @image[:src] = IMG_PATH
    @size = Point.new(SIZE, SIZE)
    @canvas = canvas
    @max_pos = Point.new(display_size.x - size.x, display_size.y - size.y)
    self.x = (max_pos.x * 0.1).to_i
    self.y = (max_pos.y * 0.5).to_i
    @bullets = Bullets.new(self)
  end

  def action!(key)
    if key.pressed? :up
      self.y -= MOVE_PER_FLAME
    end
    if key.pressed? :down
      self.y += MOVE_PER_FLAME
    end
    if key.pressed? :left
      self.x -= MOVE_PER_FLAME
    end
    if key.pressed? :right
      self.x += MOVE_PER_FLAME
    end
    self.x = 0 if x.negative?
    self.y = 0 if y.negative?
    self.x = max_pos.x if x >= max_pos.x
    self.y = max_pos.y if y >= max_pos.y

    bullets.action!
    if key.pressed? :shot
      bullets.shot!(x + SIZE, y + (SIZE / 2), key.pressed?(:boost))
    end
  end

  def display_size
    canvas.display_size
  end
end