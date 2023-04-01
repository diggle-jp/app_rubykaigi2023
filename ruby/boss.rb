class Boss < Box
  class Enemy < Box
    attr_reader :type, :killed, :bullets, :boss

    def initialize(boss, type, x, y)
      self.x = x
      self.y = y
      @boss = boss
      @type = type
      @bullets = []
      @killed = false
    end

    def action!(player)
      bullets.each { |bullet| bullet.action!(player.display_size) }
      if @attacking
        case type
        when :homing
          # 2sec後に自機に衝突する
          speed_x = ((player.x - x).to_f / (fps * 2)).to_i
          speed_y = ((player.y - y).to_f / (fps * 2)).to_i
          [
            Point.new(speed_x, speed_y),
            Point.new(speed_x + 1, speed_y + 1)
          ].each do |vector|
            bullets << Bullet.new(x, y, bullet_size, vector, 'chocolate', collision_offset: collision_offset)
          end
        when :fan
          # 270度～90度で扇状に発射
          radian = Math::PI * ((@counter.to_f / fps) + 0.5)
          [
            Point.new((Math.cos(radian) * 10).to_i, (Math.sin(radian) * 10).to_i),
            Point.new((Math.cos(radian) * 10).to_i, -1 * (Math.sin(radian) * 10).to_i),
          ].each do |vector|
            bullets << Bullet.new(x, y, bullet_size, vector, 'olive', collision_offset: collision_offset)
          end
        when :random
          4.times do
            speed_y = rand(20) - 10
            vector = Point.new(-1 * (10 - speed_y.abs), speed_y)
            bullets << Bullet.new(x, y, bullet_size, vector, 'coral', collision_offset: collision_offset)
          end
        end
        @counter += 1
        if @counter > fps
          @attacking = false 
          self.y += (50 - rand(101))
          self.y = 0 if y.negative?
          self.y = player.display_size.y if y >= player.display_size.y
        end
      end
    end

    def attack!
      @counter = 0
      @attacking = true
    end

    def hit!
      @killed = true
    end

    def reject_killed!
      bullets.reject!(&:killed)
    end

    private

    def fps
      boss.canvas.fps
    end

    def bullet_size
      Point.new(10, 10)
    end

    def collision_offset
      Box.new(3, 3, 5, 5)
    end
  end

  attr_reader :canvas, :color, :enemies, :hp, :killed

  X_SIZE = 100.freeze
  MAX_HP = 10000.freeze

  def initialize(canvas)
    @canvas = canvas
    @color = '#003e00'
    self.size = Point.new(X_SIZE, (display_size.y * 0.9).to_i)
    self.x = display_size.x - 100
    self.y = ((display_size.y - size.y) * 0.5).to_i

    enemy_distance = (size.y - 200) / 6
    @enemies = [
      Enemy.new(self, :homing, x - 20, y + 100),
      Enemy.new(self, :fan, x - 20, y + 100 + enemy_distance),
      Enemy.new(self, :random, x - 20, y + 100 + enemy_distance * 2),
      Enemy.new(self, :random, x - 20, y + 100 + enemy_distance * 3),
      Enemy.new(self, :fan, x - 20, y + 100 + enemy_distance * 4),
      Enemy.new(self, :homing, x - 20, y + 100 + enemy_distance * 5)
    ]
    @hp = MAX_HP
    @killed = false
  end

  def action!(player)
    enemies.each { |enemy| enemy.action!(player) }
    if @counter.nil? || @counter > (canvas.fps * 0.5)
      enemies.sample(2).each(&:attack!)
      @counter = 0
    end
    @counter += 1
  end

  def reject_killed!
    enemies.each(&:reject_killed!)
  end

  def hit!
    @hp -= 1
    @killed = true if hp.zero?
  end

  def remain_hp
    if hp.negative?
      0
    else
      hp.to_f / MAX_HP
    end
  end

  def display_size
    canvas.display_size
  end

  def bullets
    enemies.flat_map(&:bullets)
  end
end