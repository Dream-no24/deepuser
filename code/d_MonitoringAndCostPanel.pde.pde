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

// 이미지 로드 함수
void loadMonitoringAndCostImages() {
  monitoringImg = loadImage("../data/monitoring.png");
  costImg = loadImage("../data/TotalCostManager.png");
}

// 패널 그리기 함수
void drawMonitoringAndCostPanel(float baseYOffset) {
  swipeX += (targetSwipeX - swipeX) * swipeSensitivity; // 부드러운 이동

  float panelY = baseYOffset; // 패널 위치 조정
  pushMatrix();
  translate(swipeX, 0);

  for (int i = 0; i < shops.length; i++) {
    float x = i * width; // 점포의 x 좌표

    // 큰 박스 (반투명 배경)
    fill(0, 0, 0, 60);
    noStroke();
    rect(19 + x, panelY, 324, 340, 20);

    // 모니터링 박스와 코스트 박스 추가
    drawImagePanel(x + 6.6, panelY + 10, monitoringImg);
    drawImagePanel(x - 11.1, panelY + 110, costImg);

    // 점포 이름 출력 (박스 바깥 위 중앙)
    fill(255); // 흰색 글씨
    textSize(14);
    textAlign(CENTER, CENTER);
    text(shops[i], x + width / 2, panelY - 20); // 박스 바로 위 중앙
  }

  popMatrix();
  drawSwipeButtons(baseYOffset + 170); // 꺾쇠 버튼 그리기
}

// 이미지 패널 출력 함수
void drawImagePanel(float offsetX, float y, PImage img) {
  if (img == null) return; // 이미지 없으면 반환

  float panelWidth = (img == costImg) ? 349 : 315;
  float panelHeight = img.height * (panelWidth / img.width);
  image(img, offsetX + 17.3, y, panelWidth, panelHeight); // 이미지 출력

  fill(255); // 흰색 글씨
  textSize(11);
  textAlign(LEFT, TOP); // 텍스트 위치 설정
}

// 꺾쇠 버튼 그리기
void drawSwipeButtons(float baseYOffset) {
  fill(255); // 흰색 글씨
  textSize(12);
  textAlign(CENTER, CENTER);

  if (currentShopIndex > 0) text("<", 14, baseYOffset);
  if (currentShopIndex < shops.length - 1) text(">", width - 22, baseYOffset);
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
