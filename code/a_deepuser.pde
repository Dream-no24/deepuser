PFont regularFont, boldFont, blackFont;
PImage img;
PImage statusbar;
PImage punchhole;
PImage bezel; // 배젤 이미지 변수
boolean isLocked = false;  // 세로 스크롤 잠금 여부
float pos = 0, npos = 0;   // 현재 세로 위치와 목표 위치
float maxScrollY;          // 최대 스크롤 범위
float smoothness = 0.3;    // 부드러움 정도 (0.1 ~ 0.5 추천)

void setup() {
  size(370, 810); // 화면 크기 변경
  img = loadImage("../data/deepuser.png");
  statusbar = loadImage("../data/Statusbar.png");
  punchhole = loadImage("../data/punchhole.png");
  bezel = loadImage("../data/iPhone.png"); // 배젤 이미지 로드
  regularFont = createFont("../data/NotoSansKR-Regular.ttf", 48);
  boldFont = createFont("../data/NotoSansKR-Bold.ttf", 48);
  blackFont = createFont("../data/NotoSansKR-Black.ttf", 48);
  scheduleData = initializeScheduleData();
  filterDataWithinOneMonth();
  loadMonitoringAndCostImages(); // 이미지 로드
}

void draw() {
  textFont(regularFont);
  background(50, 50, 50);
  image(img, 5, 5, 360, 800); // 위치 조정

  // 세로 스크롤 위치 보정
  npos = constrain(npos, -maxScrollY, 0); 
  pos += (npos - pos) * smoothness; // pos가 npos에 서서히 따라감

  pushMatrix();
  translate(5, pos + 5); // 배젤 삽입으로 인한 전체 위치 조정

  // 패널들 그리기
  float infoPanelYOffset = 60;
  drawInfoPanel(infoPanelYOffset);
  float issueAndScheduleYOffset = infoPanelYOffset + 220; 
  drawIssueAndSchedulePanels(issueAndScheduleYOffset);
  float monitoringAndCostYOffset = issueAndScheduleYOffset + 200; 
  drawMonitoringAndCostPanel(monitoringAndCostYOffset);
  float calendarBaseYOffset = monitoringAndCostYOffset + 365;  
  float calendarYOffset = monitoringAndCostYOffset + 365;
  drawCalendarPanel(calendarYOffset,false);
  // 캘린더 패널의 현재 높이를 계산
  float calendarPanelHeight = getCalendarPanelHeight();

  // 테이블 패널의 Y 위치를 캘린더 아래로 조정
  float scaleFactor = isCalendarMinimized ? minimizedWidth / originalWidth : 1.0;
  float tablePanelYOffset = calendarYOffset + calendarPanelHeight + 25;

  drawTablePanel(tablePanelYOffset);

  maxScrollY = tablePanelYOffset + 230 + 50 - height;

  popMatrix();
  drawStatusBar();

  // 배젤 이미지 추가 (가장 위)
  drawBezel();
}

void drawStatusBar() {
  tint(255, 245);
  image(statusbar, 10, 15, 360, statusbar.height); // 위치 조정
  noTint();
}

void drawBezel() {
  image(bezel, 0, 0, width, height); // 배젤 이미지 전체 크기 출력
}

// 마우스 클릭 이벤트
void mousePressed() {
  float monitoringAndCostYOffset = 60 + 220 + 400 + pos;
  if (mouseX > 5 && mouseX < 365 && mouseY > monitoringAndCostYOffset - 50 && mouseY < monitoringAndCostYOffset + 50) {
    changePlacePressed(monitoringAndCostYOffset-35);
  }
  isLocked = true;
  
  infoPanelMousePressed();
  // 캘린더 클릭 감지
  float calendarYOffset = 60 + 220 + 200 + 365; // 캘린더 Y 위치 계산
  calendarMousePressed(calendarYOffset);

}

// 마우스 드래그 이벤트
void mouseDragged(MouseEvent event) {
  if (isLocked) {
    npos += mouseY - pmouseY; // npos를 업데이트 (드래그 위치를 목표로 설정)
  }
}

// 마우스 릴리즈 이벤트
void mouseReleased() {
  isLocked = false;
}
