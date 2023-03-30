class KeyEvent
  attr_reader :pressed

  def initialize(target)
    target.setAttribute('tabindex', 0)
    target.addEventListener('keydown', ->(e) { keydown(e) }, false)
    target.addEventListener('keyup', ->(e) { keyup(e) }, false)
    @pressed = Set.new
  end

  def pressed?(code)
    pressed.include? code
  end

  private

  def keydown(event)
    code = convert_key(event)
    pressed.add(code) unless code.nil?
  end

  def keyup(event)
    code = convert_key(event)
    pressed.delete(code) unless code.nil?
  end

  def convert_key(event)
    case event[:key].to_s
    when 'ArrowUp'
      :up
    when 'ArrowDown'
      :down
    when 'ArrowLeft'
      :left
    when 'ArrowRight'
      :right
    when ' '
      :shot
    when 'Shift'
      :boost
    else
      nil
    end
  end
end