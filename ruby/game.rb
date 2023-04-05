require 'js'
FPS = 60.freeze
canvas = Canvas.new(FPS)
calc = Calculation.new(canvas)
TIME_PER_FRAME = (1000 / FPS).freeze

JS.global.setInterval(-> { calc.execute! }, TIME_PER_FRAME)
