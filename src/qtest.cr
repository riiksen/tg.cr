require "qt5"

class Turtle
	property drawing
	getter heading

	DEG = Math::PI / 180.0
	@drawing = true
	@heading = 0
	@x = 400
	@y = 300
	
	def initialize()
		@qApp = Qt::Application.new
		@label = Qt::Label.new
		@qPixmap = Qt::Pixmap.new(800, 600)
		@qPixmap.fill # Qt::GlobalColor::White
		@qPainter = Qt::Painter.new @qPixmap
	end

	def show
		@qPainter.end
		@label.pixmap = @qPixmap
		@label.show
		Qt::Application.exec
	end

	def forward(amount)
		new_x = @x + dx * amount
		new_y = @y + dy * amount
		move(new_x.round.to_i, new_y.round.to_i)
	end

	def backward(amount)
		new_x = @x - dx * amount
		new_y = @y - dy * amount
		move(new_x.round.to_i, new_y.round.to_i)
	end

	def move(new_x : Int32, new_y : Int32)
		@qPainter.draw_line(@x, @y, new_x, new_y) if @drawing
		@x, @y = new_x, new_y
	end

	def right(offset)
		@heading = (@heading + offset) % 360
	end

	def left(offset)
		@heading = (@heading - offset) % 360
	end

	private def dx
		Math.cos(@heading * DEG)
	end

	private def dy
		Math.sin(@heading * DEG)
	end
end

t = Turtle.new

amount, size = gets.to_s.split.map(&.to_i)

# amount = 8
# size = 100

amount.times do
	t.forward size
	t.right 90
	t.forward size / 4
	3.times do
		t.left 90
		t.forward size / 2
	end
	t.left 90
	t.forward size / 4
	t.left 90
	t.backward size
	t.right 360 / amount
end

t.show
