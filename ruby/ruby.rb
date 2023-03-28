require 'js'
canvas = Canvas.new
calc = Calculation.new(canvas, Player.new(canvas.width, canvas.height))

FPS = 30.freeze
TIME_PER_FRAME = (1000 / FPS).freeze

JS.global.setInterval(-> { calc.exec }, TIME_PER_FRAME)
