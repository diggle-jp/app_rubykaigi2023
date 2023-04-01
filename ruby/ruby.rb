require 'js'
FPS = 30.freeze
canvas = Canvas.new
calc = Calculation.new(canvas, Player.new(canvas, FPS), Boss.new(canvas))

FPS = 30.freeze
TIME_PER_FRAME = (1000 / FPS).freeze

JS.global.setInterval(-> { calc.exec }, TIME_PER_FRAME)
