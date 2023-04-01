class Calculation
  attr_reader :canvas, :player, :boss, :key_event

  def initialize(canvas, player, boss)
    @canvas = canvas
    target = JS.global[:document].querySelector('body')
    @key_event = KeyEvent.new(target)
    @player = player
    @boss = boss
  end

  def exec
    player.action!(key_event)
    # boss.action!(player)
    canvas.render(player, boss)
  end

  private

end
