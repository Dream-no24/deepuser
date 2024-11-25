PFont font;
PImage img;

boolean isLocked = false;  // 세로 스크롤 잠금 여부
float pos = 0, npos = 0;   // 현재 세로 위치와 목표 위치

void setup() {
  size(360, 800);
  background(50, 50, 50);
  img = loadImage("../data/deepuser.png");
  font = createFont("../data/AppleSDGothicNeo.ttc", 14);
  textFont(font);
}

void draw() {
  background(50, 50, 50);
  image(img, 0, 0, width, height);

  // 세로 스크롤 위치 보정
  npos = constrain(npos, -1400, 0);
  pos += (npos - pos) * 0.1;

  pushMatrix();
  translate(0, pos);

  // 패널들 그리기
  drawInfoPanel();
  drawIssueAndSchedulePanels();
  drawMonitoringAndCostPanel(); // MonitoringAndCostPanel의 함수 호출
  drawCalendarPanel();

  popMatrix();
}

// 마우스 클릭 이벤트
void mousePressed() {
  if (!handleSwipe(mouseX, mouseY)) { // 스와이프가 아닌 경우 세로 스크롤
    isLocked = true;
  }
}

// 마우스 드래그 이벤트
void mouseDragged(MouseEvent event) {
  if (isSwipeActive()) { // 스와이프 중인 경우
    handleSwipeDragged(event);
  } else if (isLocked) {
    npos += mouseY - pmouseY; // 세로 스크롤 목표 위치 변경
  }
}

// 마우스 릴리즈 이벤트
void mouseReleased() {
  if (isSwipeActive()) {
    handleSwipeReleased();
  } else {
    isLocked = false;
  }
}
