PFont regularFont, boldFont, blackFont, swipeButtonFont;
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
  initializeShopButtonTexts(); // 텍스트 초기화 필수
  initializeButtonStates();   // 선택 상태 초기화
  img = loadImage("../data/deepuser.png");
  statusbar = loadImage("../data/Statusbar.png");
  punchhole = loadImage("../data/punchhole.png");
  bezel = loadImage("../data/iPhone.png"); // 배젤 이미지 로드
  regularFont = createFont("../data/NanumGothicCoding.ttf", 48, true);
  textFont(regularFont);
  initializeGraphData(); // 그래프 데이터 초기화
  updateGraphDataForShop(); // 초기 그래프 데이터 설정
  initializeButtonStates(); // 버튼 상태 초기화

  regularFont = createFont("../data/NotoSansKR-Regular.ttf", 48);
  boldFont = createFont("../data/NotoSansKR-Bold.ttf", 48);
  blackFont = createFont("../data/NotoSansKR-Black.ttf", 48);
  swipeButtonFont = createFont("../data/NanumGothicCoding.ttf", 48);
  scheduleData = initializeScheduleData();
  filterDataWithinOneMonth();
  loadMonitoringAndCostImages(); // 이미지 로드
}

void draw() {
  // 배경과 상태 바 먼저 그리기
  textFont(regularFont);
  background(50, 50, 50);
  image(img, 5, 5, 360, 800);

  // 세로 스크롤 위치 보정
  npos = constrain(npos, -maxScrollY, 0);
  pos += (npos - pos) * smoothness;

  pushMatrix(); // 스크롤 변환 시작
  translate(5, pos + 5); // 세로 스크롤 적용

  // 패널들 그리기
  float infoPanelYOffset = 60;
  drawInfoPanel(infoPanelYOffset);

  float issueAndScheduleYOffset = infoPanelYOffset + 220; 
  drawIssueAndSchedulePanels(issueAndScheduleYOffset);

  float monitoringAndCostYOffset = issueAndScheduleYOffset + 200;
  drawMonitoringAndCostPanel(monitoringAndCostYOffset);

  float calendarYOffset = monitoringAndCostYOffset + 365;
  drawCalendarPanel(calendarYOffset, false);

  float calendarPanelHeight = getCalendarPanelHeight();
  float tablePanelYOffset = calendarYOffset + calendarPanelHeight + 25;
  drawTablePanel(tablePanelYOffset);

  maxScrollY = tablePanelYOffset + 230 + 50 - height;

  // **점포 버튼을 스크롤 위치에 맞게 그리기**
  float panelX = 21;
  float panelY = monitoringAndCostYOffset + 160; // 버튼 Y 위치
  

  popMatrix(); // 스크롤 변환 끝

  // 상태 바 및 배젤 그리기
  drawStatusBar();
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
  float monitoringAndCostYOffset = 60 + 220 + 400 + pos; // 스크롤 오프셋 포함
  if (mouseX > 5 && mouseX < 365 && 
      mouseY > monitoringAndCostYOffset - 50 && mouseY < monitoringAndCostYOffset + 50) {
    changePlacePressed(monitoringAndCostYOffset - 35); // 스크롤 오프셋을 고려한 클릭 처리
  }

  float panelWidth = 324;
float sectionWidth = panelWidth / 4; // 각 그룹의 폭
float buttonBaseY = 60 + 220 + 400 - 95 + pos; // 버튼 Y 위치

for (int group = 0; group < 4; group++) { // 각 그룹 반복
  float groupX = 21 + (group * sectionWidth) + 45; // 그룹 시작 X 위치

  // 버튼 영역 표시 (시각화)
  fill(255, 0, 0, 100); // 반투명 빨간색으로 영역 표시
  noStroke();
  rect(groupX - sectionWidth / 2, buttonBaseY - 20, sectionWidth, 40);

  // 클릭 감지
  if (mouseX > groupX - sectionWidth / 2 && mouseX < groupX + sectionWidth / 2 &&
      mouseY > buttonBaseY - 20 && mouseY < buttonBaseY + 20) {
    // 클릭된 그룹의 텍스트 순환 (현재 점포 기준)
    rotateTextGroup(currentShopIndex, group); 
    println("Shop " + currentShopIndex + ", Group " + group + " text rotated!");
  }
}

  // 추가된 기능: 코스트 카드 아래 버튼 클릭 처리
  float buttonAreaHeight = 20; // 버튼 영역 높이
  float panelXOffset = 19; // 코스트 카드 시작 X 좌표
  float sectionWidthCost = panelWidth / 4; // 각 버튼의 가로 길이 (4개로 분할)
  float buttonY = monitoringAndCostYOffset + 100; // 버튼 영역의 Y 위치

  for (int i = 0; i < 4; i++) {
    float buttonX = panelXOffset + i * sectionWidthCost; // 각 버튼의 X 위치 계산

    // 클릭 감지 (코스트 카드 아래 버튼 자리)
    if (mouseX > buttonX && mouseX < buttonX + sectionWidthCost &&
        mouseY > buttonY && mouseY < buttonY + buttonAreaHeight) {
      if (i < currentCostImageIndex.length) {
        currentCostImageIndex[currentShopIndex] = i; // Cost 이미지 전환
        println("Shop: " + shops[currentShopIndex] + " - Switched to Cost" + (i + 1));
      }
    }
  }

  // 스크롤 잠금 활성화
  isLocked = true;

  // 추가된 패널 클릭 처리
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
