import java.lang.Math;

import javax.swing.JFrame;
import java.awt.Graphics;
import java.awt.Color;

public class Main {
	public static void main(String[] args) {
		if (args.length != 2) {
			System.out.println("Usage java Main <amount> <size>");
			System.exit(1);
		}
		int amount = Integer.parseInt(args[0]);
		int size = Integer.parseInt(args[1]);

		Turtle t = new Turtle();
	
		for (int i = 0; i < amount; i++) {
			t.forward(size);
			t.right(90);
			t.forward(size / 4);
			for (int n = 0; n < 3; n++) {
				t.left(90);
				t.forward(size / 2);
			}
			t.left(90);
			t.forward(size / 4);
			t.left(90);
			t.backward(size);
			t.right(360 / amount);
		}
	}
}

class Turtle {
	static final double deg = Math.PI / 180.0;

	public boolean drawing = true;
	public double heading = 0;
	public int x = 400;
	public int y = 300;
	
	private JFrame frame;
	
	public Turtle() {
		this.frame = new JFrame();
		this.frame.setSize(800, 600);
		this.frame.setVisible(true);
		this.frame.setBackground(Color.white);
		this.frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	public void forward(int amount) {
		double new_x = this.x + this.dx() * amount;
		double new_y = this.y + this.dy() * amount;
		move(Math.toIntExact(Math.round(new_x)), Math.toIntExact(Math.round(new_y)));
	}

	public void backward(int amount) {
		double new_x = this.x - this.dx() * amount;
		double new_y = this.y - this.dy() * amount;
		move(Math.toIntExact(Math.round(new_x)), Math.toIntExact(Math.round(new_y)));
	}
	
	public void move(int new_x, int new_y) {
		Graphics g = this.frame.getGraphics();
		System.out.println(g); // I don't know why but without this it don't work :(
		g.setColor(Color.black);
		if (this.drawing) g.drawLine(this.x, this.y, new_x, new_y);
		
		this.x = new_x;
		this.y = new_y;
	}

	public void right(double offset) {
		this.heading = (this.heading + offset) % 360;
	}

	public void left(double offset) {
		this.heading = (this.heading - offset) % 360;
	}

	private double dx() {
		return Math.cos(this.heading * this.deg);
	}

	private double dy() {
		return Math.sin(this.heading * this.deg);
	}
}
