PFont font;
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
  font = createFont("../data/NanumGothicCoding.ttf", 48, true);
  textFont(font);

  loadMonitoringAndCostImages(); // 이미지 로드
}

void draw() {
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
  drawCalendarPanel(calendarBaseYOffset);  
  float tablePanelYOffset = calendarBaseYOffset + 315;
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

void mousePressed() {
  // 기존 기능: 모니터링 및 코스트 패널 클릭
  float monitoringAndCostYOffset = 60 + 220 + 400 + pos;
  if (mouseX > 5 && mouseX < 365 && mouseY > monitoringAndCostYOffset - 50 && mouseY < monitoringAndCostYOffset + 50) {
    changePlacePressed(monitoringAndCostYOffset - 35);
  }

  // 추가된 기능: 가로 정렬된 버튼 클릭 이벤트 처리
  float panelWidth = 324; // 전체 패널의 너비324
  float sectionWidth = panelWidth / 4; // 각 그룹의 폭 (4개 그룹 기준)
  float groupY = monitoringAndCostYOffset - 95; // 버튼 그룹의 Y 위치

  for (int group = 0; group < subButtonTexts.length; group++) { 
    float groupX = 21 + (group * sectionWidth); // 그룹 시작 X 좌표
    float buttonSpacing = sectionWidth / 3; // 각 버튼 간격 (가로)

    for (int i = 0; i < subButtonTexts[group].length; i++) {
      float buttonX = groupX + (i * buttonSpacing) + buttonSpacing / 2; // 각 버튼의 X 좌표
      float buttonY = groupY; // 버튼의 Y 좌표 (고정)

      // 클릭 감지 영역 (X 범위: ±50, Y 범위: ±15)
      if (mouseX > buttonX - 10 && mouseX < buttonX + 10 && mouseY > buttonY - 15 && mouseY < buttonY + 15) {
        selectedSubButtonIndices[group] = i; // 해당 그룹의 선택된 버튼 인덱스 업데이트
        println("Group " + group + " Button: " + subButtonTexts[group][i]); // 디버깅 메시지
      }
    }
  }

  isLocked = true; // 스크롤 잠금 활성화
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
