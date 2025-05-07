const int laserPin = A3;
const int ct = 9;

bool laserPreviouslyBlocked = false;
bool timerStarted = false;
bool timerStopped = false;

double startTime = 0;
double elapsedTime = 0;
double currentTime = 0;

void setup() {
  Serial.begin(9600);
  pinMode(laserPin, INPUT);
  pinMode(ct, OUTPUT);

  delay(500);
  
  Serial.println("STATUS:PLACE_YOUR_BOT");
  tone(ct, 1200, 30);  delay(120);
  tone(ct, 1500, 30);  delay(100);
  tone(ct, 1800, 30);  delay(80);
  

  while (digitalRead(laserPin) == LOW) {
    delay(10);  // Wait until laser is initially blocked
  }

  Serial.println("STATUS:TIMER_READY");
  tone(ct, 1000, 100);
  delay(100);
  tone(ct, 1000, 100);
  delay(100);
}

void loop() {
  bool laserCurrentlyBlocked = digitalRead(laserPin) == HIGH;

  // Detect laser release (unblocked after first obstruction)
  if (laserPreviouslyBlocked && !laserCurrentlyBlocked && !timerStarted && !timerStopped) {
    timerStarted = true;
    startTime = millis();
    Serial.println("STATUS:TIMER_STARTED");
    tone(ct, 1500, 100);
  }

  // Detect second obstruction to stop timer — only if 5 seconds have passed
  if (!laserPreviouslyBlocked && laserCurrentlyBlocked && timerStarted && !timerStopped && (millis() - startTime > 5000)) {
    timerStopped = true;
    elapsedTime = (millis() - startTime) / 1000.0;

    Serial.print("STATUS:TIMER_STOPPED|FINAL=");
    Serial.println(elapsedTime, 2);

    while (true) {
      int notes[] = {1200, 1000, 800, 600};
  for (int i = 0; i < 4; i++) {
    tone(ct, notes[i], 100);
    delay(100);
    noTone(ct);
    delay(50);
  }
      // Stay here beeping
    }
  }

  // Show ongoing timer if started
  if (timerStarted && !timerStopped) {
    currentTime = (millis() - startTime) / 1000.0;
    Serial.print("TIME:");
    Serial.println(currentTime, 2);
  }

  laserPreviouslyBlocked = laserCurrentlyBlocked;
  delay(1);
}
