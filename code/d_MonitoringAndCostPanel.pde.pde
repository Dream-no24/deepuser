// 이미지 변수 선언
PImage monitoringImg;
PImage costImg;

PImage[] costImages = new PImage[4]; // 코스트 이미지 배열
int[] currentCostImageIndex = {0, 0, 0, 0}; // 각 점포의 현재 선택된 이미지 인덱스


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
void drawScaledImage(float x, float y, PImage img, float scale) {
  if (img == null) return;

  // 원본 비율을 유지하면서 크기 조정
  float panelWidth = img.width * scale;  // 폭을 scale로 조정
  float panelHeight = img.height * scale; // 높이를 scale로 조정
  image(img, x, y, panelWidth, panelHeight); // 이미지 출력
}

void loadMonitoringAndCostImages() {
  monitoringImg = loadImage("../data/monitoring.png");
  costImages[0] = loadImage("../data/Cost1.png");
  costImages[1] = loadImage("../data/Cost2.png");
  costImages[2] = loadImage("../data/Cost3.png");
  costImages[3] = loadImage("../data/Cost4.png");
}

void drawMonitoringAndCostPanel(float baseYOffset) {
    swipeX += (targetSwipeX - swipeX) * swipeSensitivity;

    float panelY = baseYOffset;
    pushMatrix();
    translate(swipeX, 0);

    for (int i = 0; i < shops.length; i++) {
        float x = i * width;

        // 큰 박스 (반투명 배경)
        fill(0, 0, 0, 60);
        noStroke();
        rect(19 + x, panelY, 324, 340, 20);

        // 모니터링 패널 이미지
        drawImagePanel(x + 23, panelY + 10, monitoringImg);

        // 모니터링 텍스트
        drawMonitoringText(x + 23, panelY + 10, 324, 340);

        // Cost 패널 이미지 (위치 조정 포함)
        if (currentCostImageIndex[i] == 0) {
            // Cost1 위치
            drawScaledImage(x + 30, panelY + 110, costImages[currentCostImageIndex[i]], 0.9);
        } else if (currentCostImageIndex[i] == 1) {
            // Cost2 위치
            drawScaledImage(x + 30, panelY + 110, costImages[currentCostImageIndex[i]], 0.9);
        } else if (currentCostImageIndex[i] == 2) {
            // Cost3 위치
            drawScaledImage(x + 30, panelY + 116, costImages[currentCostImageIndex[i]], 0.9);
        } else if (currentCostImageIndex[i] == 3) {
            // Cost4 위치 (특별한 조정)
            drawScaledImage(x + 30, panelY + 130, costImages[currentCostImageIndex[i]], 0.9);
        }

        // 점포 이름 출력
        fill(255);
        textSize(14);
        textAlign(CENTER, CENTER);
        text(shops[i], x + width / 2, panelY - 20);
    }

    popMatrix();
    drawSwipeButtons(baseYOffset + 170);
}



int[] selectedSubButtonIndices = {1, 1, 1, 1}; // 각 그룹의 선택된 버튼 인덱스 (디폴트: 표준)
String[][] subButtonTexts = {
  {"절약", "표준", "최적"},
  {"절약", "표준", "최적"},
  {"절약", "표준", "최적"},
  {"절약", "표준", "최적"}
};


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

  drawSubButtons(panelX, panelY, panelWidth, panelHeight); // 버튼 그룹 출력
}

void drawSubButtons(float panelX, float panelY, float panelWidth, float panelHeight) {
  float sectionWidth = panelWidth / subButtonTexts.length; // 각 그룹의 폭
  textAlign(CENTER, CENTER);
  
  for (int group = 0; group < subButtonTexts.length; group++) {
    float groupX = panelX + (group * sectionWidth); // 그룹 시작 X 좌표
    float groupY = panelY + panelHeight / 2 - 90; // 버튼 그룹 Y 위치
    float buttonSpacing = sectionWidth / 3; // 버튼 간 가로 간격

    for (int i = 0; i < subButtonTexts[group].length; i++) {
      float buttonX = groupX + (i * buttonSpacing) + buttonSpacing / 2; // 버튼의 X 좌표
      float buttonY = groupY; // 버튼의 Y 좌표

      // 버튼 색상 및 강조 처리
      textSize(selectedSubButtonIndices[group] == i ? 16 : 12); // 강조된 버튼 크기
      fill(selectedSubButtonIndices[group] == i ? color(255) : 200); // 강조된 버튼은 노란색
      text(subButtonTexts[group][i], buttonX, buttonY);
    }
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
