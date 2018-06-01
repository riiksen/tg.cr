#include <cstdio>
#include <cmath>

#include <QApplication>
#include <QLabel>
#include <QPixmap>
#include <QPainter>

class Turtle {
 public:
	Turtle();
	~Turtle();
	
	void forward(int);
	void backward(int);

	void move(int, int);
	void show();
	void right(float);
	void left(float);

	bool drawing = true;
	float heading = 0;

 private:
	float dx();
	float dy();
	
	int x = 400;
	int y = 300;
};
