PFont font;
PImage img;
PImage statusbar; // 상태바 이미지 변수

boolean isLocked = false;  // 세로 스크롤 잠금 여부
float pos = 0, npos = 0;   // 현재 세로 위치와 목표 위치
float maxScrollY;          // 최대 스크롤 범위

void setup() {
  size(360, 800);
  background(50, 50, 50);
  img = loadImage("../data/deepuser.png");
  statusbar = loadImage("../data/Statusbar.png");
  font = createFont("../data/NanumGothicCoding.ttf", 48, true);
  textFont(font);

  // Monitoring and Cost 이미지 로드
  loadMonitoringAndCostImages();
}

void draw() {
  background(50, 50, 50);
  image(img, 0, 0, width, height);

  // 세로 스크롤 위치 보정
  npos = constrain(npos, -maxScrollY, 0);
  pos += (npos - pos) * 0.1;

  pushMatrix();
  translate(0, pos);

  // 패널들 그리기
  float infoPanelYOffset = 60; // Cigarette Manager 패널의 Y 오프셋
  drawInfoPanel(infoPanelYOffset);
  float issueAndScheduleYOffset = infoPanelYOffset + 220; 
  drawIssueAndSchedulePanels(issueAndScheduleYOffset);
  float monitoringAndCostYOffset = issueAndScheduleYOffset + 200; 
  drawMonitoringAndCostPanel(monitoringAndCostYOffset);
  float calendarBaseYOffset = monitoringAndCostYOffset + 365; // 캘린더 위치 계산
  drawCalendarPanel(calendarBaseYOffset);  
  float tablePanelYOffset = calendarBaseYOffset + 315;
  drawTablePanel(tablePanelYOffset); // 딜리버리 테이블 호출  

  // 최대 스크롤 범위 계산
  maxScrollY = tablePanelYOffset + 230 + 50 - height;

  popMatrix();

  // 최상단에 Statusbar.png 표시
  drawStatusBar();
}

// Statusbar 이미지를 그리는 함수
void drawStatusBar() {
  tint(255, 245);
  image(statusbar, 0, 0, width, statusbar.height);
  noTint(); // 다른 이미지에 영향을 주지 않도록 tint 효과(투명도) 해제
}

// 마우스 클릭 이벤트
void mousePressed() {
  float monitoringAndCostYOffset = 60 + 180 + 400 + pos; // 해당 패널의 Y 오프셋
  changePlacePressed(monitoringAndCostYOffset); // 좌우 버튼 클릭 처리
  isLocked = true; // 세로 스크롤 활성화
}


// 마우스 드래그 이벤트
void mouseDragged(MouseEvent event) {
  if (isLocked) {
    npos += mouseY - pmouseY; // 세로 스크롤 목표 위치 변경
  }
}

// 마우스 릴리즈 이벤트
void mouseReleased() {
  isLocked = false;
}
