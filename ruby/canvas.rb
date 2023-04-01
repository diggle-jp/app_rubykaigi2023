require 'js'

class Canvas
  attr_reader :canvas, :context, :display_size

  def initialize
    @canvas = JS.global[:document].querySelector('#canvas')
    @context = canvas.getContext("2d")

    body = JS.global[:document].querySelector('body')
    @display_size = Point.new(body[:clientWidth].to_i, body[:clientHeight].to_i)

    canvas.setAttribute('width', display_size.x)
    canvas.setAttribute('height', display_size.y)
  end

  def render(player, boss)
    context.clearRect(0, 0, display_size.x, display_size.y)
    context[:fillStyle] = 'gray'
    context.fillRect(0, 0, display_size.x, display_size.y)
    context[:fillStyle] = 'black'

    x = 0
    while x < display_size.x
      y = 0
      while y < display_size.y
        context.strokeRect(x, y, 100, 100)
        y += 100
      end
      x += 100
    end
    render_player(player)
    render_boss(boss)
  end

  private

  def render_player(player)
    context.drawImage(player.image, player.x, player.y, player.size.x, player.size.y)

    player.bullets.each do |bullet|
      context[:fillStyle] = bullet.color
      context.fillRect(bullet.x, bullet.y, bullet.size.x, bullet.size.y)
    end
  end

  def render_boss(boss)
    context[:fillStyle] = boss.color
    context.fillRect(boss.x, boss.y, boss.size.x, boss.size.y)
    context[:fillStyle] = '#ffffff'

    context.beginPath();
		context.moveTo(boss.x + 50, boss.y + 50)
		context.lineTo(display_size.x, boss.y + 50)
		context.lineTo(display_size.x, boss.y + 100)
		context.closePath()
    context.fill()

    context.beginPath()
		context.moveTo(boss.x + 50, boss.y + boss.size.y - 50)
		context.lineTo(display_size.x, boss.y + boss.size.y - 50)
		context.lineTo(display_size.x, boss.y + boss.size.y - 100)
		context.closePath()
    context.fill()
  end
end
