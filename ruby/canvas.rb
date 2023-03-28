require 'js'

class Canvas
  attr_reader :canvas, :context, :width, :height
  def initialize
    @canvas = JS.global[:document].querySelector('#canvas')
    @context = canvas.getContext("2d")
    @width = canvas[:width].to_i
    @height = canvas[:height].to_i
  end

  def render(player)
    context.clearRect(0, 0, width, height)
    context[:fillStyle] = 'green'
    context.fillRect(0, 0, width, height)
    context[:fillStyle] = 'black'
    render_player(player)
  end

  private

  def render_player(player)
    context[:fillStyle] = '#0C91F1'
    context.fillRect(player.x, player.y, 10, 10)
    context[:fillStyle] = '#ED82F6'
    context[:fillStyle] = '#8186FF'
    context[:fillStyle] = '#7FDFFD'
  end
end
