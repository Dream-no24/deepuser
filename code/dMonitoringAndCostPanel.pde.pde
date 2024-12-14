// 이미지 변수 선언
PImage monitoringImg;
PImage costImg;

// 스와이프 관련 변수
float swipeX = 0;  // 현재 스와이프 위치
float targetSwipeX = 0;  // 목표 스와이프 위치
float swipeSensitivity = 0.1;  // 스와이프 감도
int currentShopIndex = 0;  // 현재 점포 인덱스
String[] shops = {
  "천안시 페터널\n습도 52%, 온도 27도, 조도 55lx, 물 2.5L",
  "개포동 컨테이너\n습도 48%, 온도 26도, 조도 60lx, 물 3.0L",
  "남현동 컨테이너\n습도 55%, 온도 28도, 조도 50lx, 물 2.8L"
};

// setup에서 호출될 이미지 로드 함수
void loadMonitoringAndCostImages() {
  monitoringImg = loadImage("../data/monitoring.png");
  costImg = loadImage("../data/TotalCostManager.png");
}

// 패널 그리기 함수
void drawMonitoringAndCostPanel(float baseYOffset) {
  // 스크롤과 정확히 동일한 수치로 이동 처리
  swipeX += (targetSwipeX - swipeX) * swipeSensitivity;

  float panelY = baseYOffset; // 위치 조정
  pushMatrix();
  translate(swipeX, 0);

  for (int i = 0; i < shops.length; i++) {
    float x = i * width; // 각 점포의 x 좌표

    // 큰 박스 (투명한 배경)
    fill(0, 0, 0, 60);
    noStroke();
    rect(15 + x, panelY, 330, 350, 20); // 반투명 검은 박스

    // 모니터링 박스에 이미지 추가
    drawImagePanel(x + 6.6, panelY + 10, monitoringImg, shops[i]);

    // 코스트 박스에 이미지 추가
    drawImagePanel(x - 11.1, panelY + 110, costImg, "매출 10000원 당 4294원");
  }

  popMatrix();

  // 좌우 버튼 그리기
  drawSwipeButtons(baseYOffset + 150); // 버튼도 동일 스크롤 기준으로 이동
}

// 이미지를 포함한 패널 출력 함수
void drawImagePanel(float offsetX, float y, PImage img, String content) {
  if (img == null) {
    println("이미지 로드 실패: 기본 배경을 사용합니다.");
    return;
  }

  // 패널 너비 조건
  float panelWidth = (img == costImg) ? 349 : 315;

  // 이미지 비율에 따라 세로 길이 조정
  float panelHeight = img.height * (panelWidth / img.width);

  // 이미지 출력
  image(img, 17.3 + offsetX, y, panelWidth, panelHeight);

  // 텍스트 출력
  fill(0);
  textSize(11);
  text(content, 43 + offsetX, y + panelHeight + 10);
}
// 좌우 꺾쇠 버튼 그리기
void drawSwipeButtons(float baseYOffset) {
  fill(255);
  textSize(20);

  float yOffset = baseYOffset; // 꺾쇠 버튼의 y 위치 계산

  // 왼쪽 버튼
  if (currentShopIndex > 0) {
    textAlign(CENTER, CENTER);
    text("<", 7, yOffset); // 왼쪽 버튼 표시
  }

  // 오른쪽 버튼
  if (currentShopIndex < shops.length - 1) {
    textAlign(CENTER, CENTER);
    text(">", width - 7, yOffset); // 오른쪽 버튼 표시
  }
}

// 좌우 버튼 클릭 처리
void changePlacePressed(float baseYOffset) {
  float yOffset = baseYOffset; // 꺾쇠 버튼의 y 위치 계산

  // 왼쪽 버튼 클릭
  if (mouseX > 0 && mouseX < 30 && mouseY > yOffset - 30 && mouseY < yOffset + 30 && currentShopIndex > 0) {
    currentShopIndex--;
    targetSwipeX = -currentShopIndex * width;
    println("왼쪽 버튼 클릭 - currentShopIndex: " + currentShopIndex);
  }

  // 오른쪽 버튼 클릭
  if (mouseX > 330 && mouseX < 360 && mouseY > yOffset - 30 && mouseY < yOffset + 30 && currentShopIndex < shops.length - 1) {
    currentShopIndex++;
    targetSwipeX = -currentShopIndex * width;
    println("오른쪽 버튼 클릭 - currentShopIndex: " + currentShopIndex);
  }
}
