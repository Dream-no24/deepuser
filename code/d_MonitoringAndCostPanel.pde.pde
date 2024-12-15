// 이미지 변수 선언
PImage monitoringImg;
PImage costImg;

// 스와이프 관련 변수
float swipeX = 0;  // 현재 스와이프 위치
float targetSwipeX = 0;  // 목표 스와이프 위치
float swipeSensitivity = 0.3;  // 스와이프 감도
int currentShopIndex = 0;  // 현재 점포 인덱스
String[] shops = {
  "천안시 페터널",
  "개포동 컨테이너",
  "남현동 컨테이너",
  "과천동 컨테이너"
};
// 텍스트 값과 단위 정의
String[][] panelText = {
  {" 52", "%"}, 
  {" 27", "°"}, 
  {"55", "lx"}, 
  {"2.5", "h"}
};

// 이미지 로드 함수
void loadMonitoringAndCostImages() {
  monitoringImg = loadImage("../data/monitoring.png");
  costImg = loadImage("../data/TotalCostManager.png");
}
void drawMonitoringAndCostPanel(float baseYOffset) {
  swipeX += (targetSwipeX - swipeX) * swipeSensitivity; // 부드러운 이동

  float panelY = baseYOffset; // 패널의 Y 위치
  pushMatrix();
  translate(swipeX, 0); // 스와이프 이동 적용

  for (int i = 0; i < shops.length; i++) {
    float x = i * width; // 각 점포의 X 위치

    // 큰 박스 (반투명 배경)
    fill(0, 0, 0, 60);
    noStroke();
    rect(19 + x, panelY, 324, 340, 20);

    // 모니터링 패널 이미지
    drawImagePanel(x + 19, panelY + 10, monitoringImg);

    // 모니터링 텍스트
    drawMonitoringText(x + 19, panelY + 10, 324, 340);

    // 코스트 패널 이미지
    drawImagePanel(x + 19, panelY + 110, costImg);

    // 점포 이름 출력
    fill(255); // 흰색 글씨
    textSize(14);
    textAlign(CENTER, CENTER);
    text(shops[i], x + width / 2, panelY - 20); // 패널 위 중앙에 이름 표시
  }

  popMatrix();

  // 꺾쇠 버튼 (스와이프 이동에 영향을 받지 않음)
  drawSwipeButtons(baseYOffset + 170);
}

// 버튼 상태 변수
int selectedButtonIndex = -1; // 눌린 버튼 인덱스 (-1은 선택되지 않음)
String[] buttonTexts = {"Button 1", "Button 2", "Button 3", "Button 4"}; // 버튼 텍스트

void drawMonitoringText(float panelX, float panelY, float panelWidth, float panelHeight) {
  float sectionWidth = panelWidth / panelText.length; // 각 텍스트 블록의 폭
  textAlign(CENTER, CENTER);
  textSize(28);

  // 숫자와 단위 출력
  for (int i = 0; i < panelText.length; i++) {
    float x = panelX + (i * sectionWidth) + sectionWidth / 2; // 중앙 정렬된 X 좌표
    float y = panelY + panelHeight / 2; // 패널 중앙 Y 좌표

    fill(255); // 숫자와 단위는 흰색 고정
    text(panelText[i][0], x - 10, y - 120); // 숫자 출력
    textSize(20);
    text(panelText[i][1], x + 15, y - 117); // 단위 출력
    textSize(28); // 크기 복원
  }

  // 버튼 텍스트 출력
  drawTextButtons(panelX, panelY, panelWidth, panelHeight, sectionWidth);
}

// 버튼 텍스트 출력
void drawTextButtons(float panelX, float panelY, float panelWidth, float panelHeight, float sectionWidth) {
  textAlign(CENTER, CENTER);

  for (int i = 0; i < buttonTexts.length; i++) {
    float x = panelX + (i * sectionWidth) + sectionWidth / 2; // 버튼 중앙 X 좌표
    float y = panelY + panelHeight / 2 - 90; // 버튼 Y 좌표

    // 버튼 색상 및 크기 처리
    textSize(selectedButtonIndex == i ? 24 : 18); // 강조 크기
    fill(selectedButtonIndex == i ? color(255, 255, 0) : 255); // 강조된 버튼은 노란색
    text(buttonTexts[i], x, y);
  }
}

// 이미지 출력 함수
void drawImagePanel(float offsetX, float offsetY, PImage img) {
  if (img == null) return; // 이미지가 없으면 반환
  float panelWidth = 315;
  float panelHeight = img.height * (panelWidth / img.width); // 비율에 맞게 높이 계산
  image(img, offsetX, offsetY, panelWidth, panelHeight);
}

// 꺾쇠 버튼 그리기
void drawSwipeButtons(float baseYOffset) {
  fill(255); // 흰색 글씨
  textSize(28);
  textAlign(CENTER, CENTER);

  // 왼쪽 버튼
  if (currentShopIndex > 0) {
    text("<", 30, baseYOffset); // 왼쪽 버튼 위치
  }

  // 오른쪽 버튼
  if (currentShopIndex < shops.length - 1) {
    text(">", width - 30, baseYOffset); // 오른쪽 버튼 위치
  }
}


// 좌우 버튼 클릭 처리
void changePlacePressed(float baseYOffset) {
  float yOffset = baseYOffset; // 꺾쇠 버튼의 y 위치 계산

  // 왼쪽 버튼 클릭
  if (mouseX > 0 && mouseX < 50 && mouseY > yOffset - 50 && mouseY < yOffset + 50 && currentShopIndex > 0) {
    currentShopIndex--;
    targetSwipeX = -currentShopIndex * width;
  }

  // 오른쪽 버튼 클릭
  if (mouseX > width - 50 && mouseX < width && mouseY > yOffset - 50 && mouseY < yOffset + 50 && currentShopIndex < shops.length - 1) {
    currentShopIndex++;
    targetSwipeX = -currentShopIndex * width;
  }
}
