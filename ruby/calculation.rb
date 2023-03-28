class Calculation
  attr_reader :canvas, :player, :player_offset

  PLAYER_OFFSET = 5.freeze

  def initialize(canvas, player)
    @canvas = canvas
    set_event(canvas.canvas)
    @player = player
    @player_offset = Point.new(0, 0)
  end

  def exec
    player.move!(player_offset)
    canvas.render(player)
  end

  private

  def keydown(event)
    event.stopPropagation
    case event[:key].to_s
    when 'ArrowUp'
      player_offset.y = -1
    when 'ArrowDown'
      player_offset.y = 1
    when 'ArrowLeft'
      player_offset.x = -1
    when 'ArrowRight'
      player_offset.x = 1
    end
  end

  def keyup(event)
    case event[:key].to_s
    when 'ArrowUp', 'ArrowDown'
      player_offset.y = 0
    when 'ArrowLeft', 'ArrowRight'
      player_offset.x = 0
    end
  end

  def set_event(canvas)
    canvas.setAttribute('tabindex', 0)
    canvas.addEventListener('keydown', ->(e) { keydown(e) }, false)
    canvas.addEventListener('keyup', ->(e) { keyup(e) }, false)
  end
end
