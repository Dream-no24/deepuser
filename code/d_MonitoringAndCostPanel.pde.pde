// 이미지 변수 선언
PImage monitoringImg;
PImage costImg;

// 스와이프 관련 변수
float swipeX = 0;             // 현재 스와이프 위치
float targetSwipeX = 0;       // 목표 스와이프 위치
float swipeSensitivity = 0.3; // 스와이프 감도
int currentShopIndex = 0;     // 현재 점포 인덱스
String[] shops = {
  "천안시 페터널",
  "개포동 컨테이너",
  "남현동 컨테이너",
  "과천동 컨테이너"
};

// 이미지 로드 함수
void loadMonitoringAndCostImages() {
  monitoringImg = loadImage("../data/monitoring.png");
  costImg       = loadImage("../data/TotalCostManager.png");
}

// 패널 그리기 함수
void drawMonitoringAndCostPanel(float baseYOffset) {
  swipeX += (targetSwipeX - swipeX) * swipeSensitivity; // 부드러운 이동 보정

  float panelY = baseYOffset; // 패널 기본 Y 위치
  pushMatrix();
  translate(swipeX, 0);

  for (int i = 0; i < shops.length; i++) {
    float x = i * width; // i번째 점포 패널의 X 좌표

    // 큰 박스 (반투명 배경)
    fill(0, 0, 0, 60);
    noStroke();
    rect(19 + x, panelY, 324, 340, 20);

    // 모니터링 박스와 코스트 박스
    drawImagePanel(x + 6.6,  panelY + 10,  monitoringImg);
    drawImagePanel(x - 11.1, panelY + 110, costImg);

    // 점포 이름(박스 위 중앙)에 표시
    // ─────────────────────────────────────────────
    textAlign(CENTER, CENTER);

    // 현재 인덱스인 패널 → 흰색 / 양옆에 이전·다음 이름은 회색
    if (i == currentShopIndex) {
      // 현재 점포(흰색)
      textFont(boldFont);
      textSize(16);
      fill(255);
      text(shops[i], x + width/2, panelY - 20);
      textFont(regularFont);

      // 이전 점포(회색) - 있으면 표시
      if (i > 0) {
        textSize(12);
        fill(150);
        // 원하는 위치만큼 좌우 간격을 조절한다. 여기서는 -120 정도로 가정
        text(shops[i - 1], x + width/2 - 100, panelY - 20);
      }

      // 다음 점포(회색) - 있으면 표시
      if (i < shops.length - 1) {
        textSize(12);
        fill(150);
        // 여기서는 +120 정도로 가정
        text(shops[i + 1], x + width/2 + 100, panelY - 20);
      }
    } 
    else {
      // 현재 인덱스가 아닌 패널은 굳이 텍스트를 안 그려도 되지만,
      // 패널마다 '자기 점포명'을 희미하게나마 표시하려면 다음처럼 가능:
      fill(120);
      text(shops[i], x + width/2, panelY - 20);
    }
    // ─────────────────────────────────────────────

  }

  popMatrix();

  // 꺾쇠 버튼 그리기
  drawSwipeButtons(baseYOffset + 170);
}

// 이미지 패널 출력 함수
void drawImagePanel(float offsetX, float y, PImage img) {
  if (img == null) return; // 이미지가 없으면 처리하지 않음

  float panelWidth  = (img == costImg) ? 349 : 315;
  float panelHeight = img.height * (panelWidth / img.width);
  image(img, offsetX + 17.3, y, panelWidth, panelHeight); // 이미지 출력

  // 텍스트 등 다른 요소를 넣고 싶다면 여기서 추가
  fill(255);
  textSize(11);
  textAlign(LEFT, TOP);
}

// 꺾쇠 버튼 그리기 함수
void drawSwipeButtons(float baseYOffset) {
  fill(255); 
  textSize(12);
  textAlign(CENTER, CENTER);

  // 왼쪽 꺾쇠
  if (currentShopIndex > 0) {
    text("<", 14, baseYOffset);
  }
  // 오른쪽 꺾쇠
  if (currentShopIndex < shops.length - 1) {
    text(">", width - 22, baseYOffset);
  }
}

// 좌우 버튼 클릭 처리
void changePlacePressed(float baseYOffset) {
  float yOffset = baseYOffset; // 꺾쇠 버튼의 Y위치

  // 왼쪽 버튼 클릭 감지
  if (mouseX > 0 && mouseX < 50 &&
      mouseY > yOffset - 50 && mouseY < yOffset + 50 &&
      currentShopIndex > 0) {
    currentShopIndex--;
    targetSwipeX = -currentShopIndex * width;
  }

  // 오른쪽 버튼 클릭 감지
  if (mouseX > width - 50 && mouseX < width &&
      mouseY > yOffset - 50 && mouseY < yOffset + 50 &&
      currentShopIndex < shops.length - 1) {
    currentShopIndex++;
    targetSwipeX = -currentShopIndex * width;
  }
}
