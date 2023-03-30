class Calculation
  attr_reader :canvas, :player, :key_event

  def initialize(canvas, player)
    @canvas = canvas
    target = JS.global[:document].querySelector('body')
    @key_event = KeyEvent.new(target)
    @player = player
  end

  def exec
    player.action!(key_event)
    canvas.render(player)
  end

  private

end
