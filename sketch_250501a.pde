import processing.serial.*;

Serial port;

String status = "Waiting...";
float elapsedTime = 0;
float finalTime = 0;

PFont font;
boolean timerStopped = false;
boolean newStatus = true;
float barWidth = 0;

float shakeAmount = 0;
float shakeSpeed = 0.025;
boolean shakeFinalTime = false;

// Particle Class for Bar Animation
class Particle {
  float x, y, speedX, speedY, alpha;

  Particle(float bx, float by) {
    x = bx + random(0, barWidth);
    y = by + random(-10, 40);
    speedX = random(0.5, 1.5);
    speedY = random(-0.5, 0.5);
    alpha = 255;
  }

  void update() {
    x += speedX;
    y += speedY;
    alpha -= 1.5;
  }

  void display() {
    noStroke();
    fill(0, 255, 100, alpha);
    ellipse(x, y, 5, 5);
  }

  boolean isDead() {
    return alpha <= 0;
  }
}

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup() {
  fullScreen(); // This makes the sketch run in full screen
  background(0);
  size(800, 600);
  font = createFont("Arial", 20);
  textFont(font);
  textAlign(CENTER, CENTER);
  background(0);

  String portName = "/dev/tty.usbserial-1120";  // Change as needed
  port = new Serial(this, portName, 9600);
  port.bufferUntil('\n');
}

void draw() {
  background(0);

  // Title
  fill(155);
  textSize(110);
  text("~ Line Follower Timer ~", width/2, 100);

  // Status
  if (newStatus) {
    textSize(60);
    text("Status: " + status, width/2, 250);

    if (status.equals("Timer Running...")) {
      drawStyledClock(width/2 - 0, 590);
    }
  }

  // Timer running
  if (!timerStopped) {
    text("Current Time: " + nf(elapsedTime, 0, 2) + " s", width/2, 450);

    // Faster progress bar (1.75x)
    float targetWidth = map(elapsedTime * 1.75, 0, 300, 0, width - 100);
    barWidth = lerp(barWidth, targetWidth, 0.1);

    // Base bar
    noStroke();
    fill(0, 255, 0);
    rect(50, 350, barWidth, 30);

    // Glow effect (pulse)
    fill(0, 255, 100, 80 + 50 * sin(frameCount * 0.1));
    rect(50, 350, barWidth, 30);

    // Particle animation
    if (frameCount % 2 == 0) {
      particles.add(new Particle(50, 350));
    }

    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      p.display();
      if (p.isDead()) {
        particles.remove(i);
      }
    }

  } else {
    if (shakeFinalTime) {
      shakeAmount = sin(millis() * shakeSpeed) * 10;
    }
    fill(255, 0, 0);

    pushMatrix();
    translate(width / 2 + shakeAmount, 400);
    scale(2);
    textSize(36);
    text("Final Time: " + nf(finalTime, 0, 2) + " s", 0, 0);
    popMatrix();
  }
}

void drawStyledClock(float x, float y) {
  pushMatrix();

  float shake = sin(millis() * 0.01) * 3;
  float bob = sin(millis() * 0.005) * 5;
  translate(x + shake, y + bob);

  float radius = 60;

  stroke(100);
  strokeWeight(4);
  fill(30);
  ellipse(0, 0, radius * 2, radius * 2);

  noStroke();
  fill(60);
  ellipse(0, 0, radius * 1.8, radius * 1.8);

  float hourAngle = radians((millis() / 1000.0) * 30 % 360);
  float minuteAngle = radians((millis() / 100.0) * 6 % 360);

  stroke(155);
  strokeWeight(3);
  line(0, 0, 0.5 * radius * cos(hourAngle - HALF_PI), 0.5 * radius * sin(hourAngle - HALF_PI));

  stroke(100, 255, 100);
  strokeWeight(2);
  line(0, 0, 0.8 * radius * cos(minuteAngle - HALF_PI), 0.8 * radius * sin(minuteAngle - HALF_PI));

  noStroke();
  fill(255, 0, 0);
  ellipse(0, 0, 6, 6);

  popMatrix();
}

void serialEvent(Serial p) {
  String data = trim(p.readStringUntil('\n'));
  if (data == null) return;

  if (data.startsWith("STATUS:")) {
    newStatus = true;
    if (data.contains("PLACE_YOUR_BOT")) {
      status = "Place Your Bot";
    } else if (data.contains("TIMER_READY")) {
      status = "Timer Ready!";
    } else if (data.contains("TIMER_STARTED")) {
      status = "Timer Running...";
    } else if (data.contains("TIMER_STOPPED")) {
      status = "Timer Stopped!";
      String[] parts = split(data, "=");
      if (parts.length == 2) {
        finalTime = float(parts[1]);
        timerStopped = true;
        shakeFinalTime = true;
      }
    }
  } else if (data.startsWith("TIME:")) {
    try {
      elapsedTime = float(split(data, ":")[1]);
    } catch (Exception e) {
      println("Error parsing TIME: " + e.getMessage());
    }
  }
}
 
