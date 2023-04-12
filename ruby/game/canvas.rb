require 'js'

class Canvas
  attr_reader :canvas, :context, :display_size, :fps

  def initialize(fps)
    @fps = fps
    @canvas = JS.global[:document].querySelector('#canvas')
    @context = canvas.getContext("2d")

    body = JS.global[:document].querySelector('body')
    @display_size = Point.new(body[:clientWidth].to_i, body[:clientHeight].to_i)

    canvas.setAttribute('width', display_size.x)
    canvas.setAttribute('height', display_size.y)
  end

  def render_menu
    @counter = 0 if @counter.nil? || @counter > fps * 2
    @counter += 1

    context.clearRect(0, 0, display_size.x, display_size.y)
    context[:fillStyle] = 'black'
    render_text('GAME for Ruby Kaigi 2023', display_center.x, display_center.y - 25, 'center', 50)

    if @counter > fps * 0.75
      render_text('- Press SPACE to start -', display_center.x, display_center.y + 25, 'center', 25)
    end

    render_text('このゲームはruby.wasmで実装しています', display_center.x, display_size.y - 150, 'center', 25)
    render_text('操作方法などはブースで説明しておりますので、お気軽にお越しください', display_center.x, display_size.y - 100, 'center', 25)

    render_text('Presened by DIGGLE Inc.', display_size.x, display_size.y - 10, 'right', 15)
    render_fps
  end

  def render_game(player, boss)
    context.clearRect(0, 0, display_size.x, display_size.y)
    context[:fillStyle] = 'lightgray'
    context.fillRect(0, 0, display_size.x, display_size.y)
    context[:fillStyle] = 'black'

    render_player(player)
    render_boss(boss)
    render_fps
  end

  def render_gameover(player, boss)
    render_game(player, boss)

    @counter = 0 if @counter.nil? || @counter > fps * 2
    @counter += 1

    context[:fillStyle] = 'black'
    render_text('GAME OVER', display_center.x, display_center.y - 25, 'center', 50)

    if @counter > fps * 0.75
      render_text('- Press ENTER to back -', display_center.x, display_center.y + 25, 'center', 25)
    end
    render_fps
  end

  def render_clear(player, boss, timer)
    render_game(player, boss)

    @counter = 0 if @counter.nil? || @counter > fps * 2
    @counter += 1

    context[:fillStyle] = 'black'
    render_text('Congratulation!', display_center.x, display_center.y - 50, 'center', 50)
    render_text("Clear time: #{timer.time}sec", display_center.x, display_center.y, 'center', 25)

    if @counter > fps * 0.75
      render_text('- Press ENTER to back -', display_center.x, display_center.y + 50, 'center', 25)
    end

    render_text('このページを表示した状態で弊社ブースへお越しください', display_center.x, display_size.y - 100, 'center', 25)
    render_fps
  end

  private

  def display_center
    @display_center ||= Point.new((display_size.x * 0.5).to_i, (display_size.y * 0.5).to_i)
  end

  def render_player(player)
    context.drawImage(player.image, player.x, player.y, player.size.x, player.size.y)
    context[:fillStyle] = 'black'

    player.bullets.each do |bullet|
      context[:fillStyle] = bullet.color
      context.fillRect(bullet.x, bullet.y, bullet.size.x, bullet.size.y)
    end
  end

  def render_boss(boss)
    context[:fillStyle] = boss.color
    context.fillRect(boss.x, boss.y, boss.size.x, boss.size.y)
    context[:fillStyle] = 'white'

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

    hp_bar_size = display_size.x - 100
    context[:fillStyle] = 'red'
    context.fillRect(50, 10, hp_bar_size, 20)
    context[:fillStyle] = 'green'
    context.fillRect(50, 10, (hp_bar_size * boss.remain_hp).to_i, 20)

    boss.bullets.each do |bullet|
      context[:fillStyle] = bullet.is_killer ? 'red' : bullet.color
      context.fillRect(bullet.x, bullet.y, bullet.size.x, bullet.size.y)
    end
  end

  def render_fps
    @fps_counter ||= 0
    @lasttime ||= Time.now
    if @fps_counter >= fps / 2
      time = Time.now - @lasttime
      @last_fps = (@fps_counter / time).round(1)
      @lasttime = Time.now
      @fps_counter = 0
    end
    @fps_counter += 1
    context[:fillStyle] = 'black'
    render_text("FPS:#{@last_fps}", 0, 10, 'left', 10) unless @last_fps.nil?
  end

  def render_text(text, x, y, position, size)
    context[:textAlign] = position
    context[:font] = "#{size}px Arial"
    context.fillText(text, x, y)
  end
end
