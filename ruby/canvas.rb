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

  def render(player)
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
  end

  private

  def render_player(player)
    context.drawImage(player.image, player.x, player.y, player.size.x, player.size.y)

    player.bullets.each do |bullet|
      context[:fillStyle] = bullet.color
      context.fillRect(bullet.x, bullet.y, 10, 10)
    end
  end
end
