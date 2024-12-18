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
  initializeGraphData(); // 그래프 데이터 초기화
  updateGraphDataForShop(); // 초기 그래프 데이터 설정

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
int lastClickTime = 0; // 마지막 클릭 시간
int doubleClickThreshold = 300; // 더블클릭 간격 (ms)
boolean isPendingSingleClick = false; // 단순 클릭 대기 상태
boolean buttonClicked = false; // 버튼 클릭 여부 플래그

void mousePressed() {
  int currentTime = millis(); // 현재 시간 기록
  boolean isDoubleClick = false; // 더블클릭 여부 플래그

  // 더블클릭 확인
  if (currentTime - lastClickTime < doubleClickThreshold) {
    isDoubleClick = true;
    isPendingSingleClick = false; // 단순 클릭 대기 취소
    lastClickTime = 0; // 더블클릭 후 타이머 초기화
  } else {
    // 단순 클릭 대기 상태 설정
    isPendingSingleClick = true;
    lastClickTime = currentTime;
  }

  float monitoringAndCostYOffset = 60 + 220 + 400 + pos;

  // 꺽새 버튼 클릭 처리
  float yOffset = monitoringAndCostYOffset - 35; // 꺽새 버튼의 Y 위치 계산

  // 왼쪽 버튼 클릭
  if (mouseX > 0 && mouseX < 50 && mouseY > yOffset - 50 && mouseY < yOffset + 50 && currentShopIndex > 0) {
    currentShopIndex--;
    updateGraphDataForShop();
    targetSwipeX = -currentShopIndex * width; // 스와이프 위치 업데이트
    println("Switched to Shop: " + shops[currentShopIndex]);
    isLocked = true; // 스크롤 잠금
    return; // 꺽새 버튼이 클릭된 경우 다른 로직 실행 방지
  }

  // 오른쪽 버튼 클릭
  if (mouseX > width - 50 && mouseX < width && mouseY > yOffset - 50 && mouseY < yOffset + 50 && currentShopIndex < shops.length - 1) {
    currentShopIndex++;
    updateGraphDataForShop();
    targetSwipeX = -currentShopIndex * width; // 스와이프 위치 업데이트
    println("Switched to Shop: " + shops[currentShopIndex]);
    isLocked = true; // 스크롤 잠금
    return; // 꺽새 버튼이 클릭된 경우 다른 로직 실행 방지
  }

  // 텍스트 버튼 클릭 감지
  float panelWidth = 324; // 전체 패널 너비
  float sectionWidth = panelWidth / 4; // 각 그룹의 폭
  float buttonY = monitoringAndCostYOffset - 95; // 텍스트 버튼 Y 위치

  buttonClicked = false; // 클릭 여부 초기화

  for (int group = 0; group < 4; group++) {
    float groupX = 21 + (group * sectionWidth);
    float buttonSpacing = sectionWidth / 3;

    for (int i = 0; i < subButtonTexts[currentShopIndex][group].length; i++) {
      float buttonX = groupX + (i * buttonSpacing) + buttonSpacing / 2;
      float buttonYFixed = buttonY;

      if (mouseX > buttonX - 20 && mouseX < buttonX + 20 &&
          mouseY > buttonYFixed - 20 && mouseY < buttonYFixed + 20) {
        buttonClicked = true; // 버튼 클릭 상태 활성화
        if (isDoubleClick) {
          rotateButtonOrder(group); // 더블클릭 시 버튼 순서 회전
          println("Double Clicked: Group " + group + ", Button " + i);
        }
      }
    }
  }

  // 추가된 기능: 코스트 패널 아래 버튼 클릭 처리
  float buttonAreaHeight = 20; // 버튼 영역 높이
  float panelXOffset = 19; // 코스트 패널 시작 X 좌표
  float sectionWidthCost = panelWidth / 4; // 코스트 버튼 너비
  float costButtonY = monitoringAndCostYOffset + 100; // 코스트 버튼 Y 위치

  for (int i = 0; i < 4; i++) {
    float buttonX = panelXOffset + i * sectionWidthCost; // 각 버튼의 X 위치

    // 클릭 영역 감지
    if (mouseX > buttonX && mouseX < buttonX + sectionWidthCost &&
        mouseY > costButtonY && mouseY < costButtonY + buttonAreaHeight) {
      currentCostImageIndex[currentShopIndex] = i; // 이미지 인덱스 변경
      println("Shop: " + shops[currentShopIndex] + " - Switched to Cost" + (i + 1));
      buttonClicked = true; // 버튼 클릭 상태 활성화
    }
  }

  // 버튼 클릭 시 스크롤 잠금, 버튼 클릭이 없으면 스크롤 활성화
  isLocked = buttonClicked;
}

// 단순 클릭 지연 처리
void delayDoubleClick(int group) {
  new Thread(() -> {
    try {
      Thread.sleep(doubleClickThreshold); // 더블클릭 대기 시간만큼 지연
      if (isPendingSingleClick) {
        // 대기 시간이 지나도 더블클릭 발생하지 않으면 단순 클릭 처리
        println("Single Click Detected: Group " + group);
        isPendingSingleClick = false;
      }
    } catch (InterruptedException e) {
      println("Error in delayDoubleClick: " + e);
    }
  }).start();
}

void rotateButtonOrder(int group) {
  int shopIndex = currentShopIndex; // 현재 점포 인덱스

  // 현재 점포의 버튼 순서 회전
  String[] buttons = subButtonTexts[shopIndex][group];
  String temp = buttons[0];
  for (int i = 0; i < buttons.length - 1; i++) {
    buttons[i] = buttons[i + 1];
  }
  buttons[buttons.length - 1] = temp;

  // 선택된 버튼 인덱스는 항상 가운데 (1)
  selectedSubButtonIndices[shopIndex][group] = 1;
}

// 스크롤 이벤트 처리
void mouseDragged() {
  if (!isLocked) { // 버튼 클릭으로 잠겨있지 않을 때만 스크롤 처리
    npos += mouseY - pmouseY; // npos를 업데이트 (드래그 위치를 목표로 설정)
  }
}

void mouseReleased() {
  isLocked = false; // 스크롤 잠금 해제
}
