class Calculation
  class Timer
    attr_reader :start, :stop
    def start!
      @start = Time.now
      @stop = nil
    end

    def stop!
      @stop = Time.now
    end

    def time
      return nil if start.nil?
      end_time = stop.nil? ? Time.now : stop
      end_time - start
    end
  end

  attr_reader :canvas, :player, :boss, :key_event, :status, :timer

  def initialize(canvas)
    @canvas = canvas
    target = JS.global[:document].querySelector('body')
    @key_event = KeyEvent.new(target)
    @status = :start_menu
    @timer = Timer.new
  end

  def execute!
    send("exec_#{status}")
  end

  private

  def exec_start_menu
    if key_event.pressed?(:shot)
      start_game!
    else
      canvas.render_menu
    end
  end

  def exec_game
    player.action!(key_event)
    boss.action!(player)
    detect_collision!(boss, player.bullets)
    # detect_collision!(player, boss.bullets)
    player.reject_killed!
    boss.reject_killed!

    canvas.render_game(player, boss)

    if player.killed
      timer.stop!
      @status = :gameover
    elsif boss.killed
      timer.stop!
      @status = :clear
    end

    # p "player:#{player.bullets.bullets.length}"
    # p "boss:#{boss.bullets.length}"
  end

  def exec_gameover
    if key_event.pressed?(:enter)
      @status = :start_menu
    else
      canvas.render_gameover(player, boss)
    end
  end

  def exec_clear
    if key_event.pressed?(:enter)
      @status = :start_menu
    else
      canvas.render_clear(player, boss, timer)
    end
  end

  private

  def detect_collision!(target, attackers)
    attackers.each do |attacker|
      if target.collision_area.hit?(attacker.collision_area)
        target.hit!
        attacker.hit!
      end
    end
  end

  def start_game!
    timer.start!
    @status = :game 
    @player = Player.new(canvas)
    @boss = Boss.new(canvas)
  end
end
