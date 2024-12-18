// 이미지 변수 선언
PImage monitoringImg;
PImage costImg;

PImage[] costImages = new PImage[4]; // 코스트 이미지 배열
int[] currentCostImageIndex = {0, 0, 0, 0}; // 각 점포의 현재 선택된 이미지 인덱스


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
// 텍스트 값과 단위 정의
String[][] panelText = {
  {" 52", "%"}, 
  {" 27", "°"}, 
  {"55", "lx"}, 
  {"2.5", "h"}
};
float[][] shopGraphData1 = new float[4][30]; // 그래프 데이터 1
float[][] shopGraphData2 = new float[4][30]; // 그래프 데이터 2
float[][] shopGraphData3 = new float[4][30]; // 그래프 데이터 3
void generateRandomGraphData(float[] data, int minVal, int maxVal) {
  int length = 30; // 고정된 길이
  for (int i = 0; i < length; i++) {
    data[i] = random(minVal, maxVal); // 지정된 범위 내 랜덤 값 생성
  }
}

void initializeGraphData() {
  for (int i = 0; i < 4; i++) { // 점포 4개
    generateRandomGraphData(shopGraphData1[i], 20, 80); // 그래프 1 범위: 20 ~ 80
    generateRandomGraphData(shopGraphData2[i], 10, 60); // 그래프 2 범위: 10 ~ 60
    generateRandomGraphData(shopGraphData3[i], 0, 50);  // 그래프 3 범위: 0 ~ 50
  }
}
void updateGraphDataForShop() {
  if (currentShopIndex >= 0 && currentShopIndex < shopGraphData1.length) {
    int minLength = min(shopGraphData1[currentShopIndex].length, graphData1.length);

    for (int i = 0; i < minLength; i++) {
      graphData1[i] = shopGraphData1[currentShopIndex][i];
      graphData2[i] = shopGraphData2[currentShopIndex][i];
      graphData3[i] = shopGraphData3[currentShopIndex][i];
    }
  } else {
    println("Invalid shop index: " + currentShopIndex);
  }
}

// 그래프 결과 변수 선언
float monthCost1, monthCost2, monthCost3;
// 그래프 데이터
float[] graphData1 = {30, 60, 50, 60, 70, 80, 60, 30, 20, 60, 80, 40, 50, 40, 70,
                      70, 50, 40, 30, 40, 50, 40, 30, 70, 60, 80, 60, 50, 30};
float[] graphData2 =  {10, 10, 9, 30, 40, 50, 45, 10, 25, 15, 25, 30, 55, 45, 35,
                     15, 35, 25, 10, 50, 55, 40, 30, 20, 20, 25, 45, 55, 35};
float[] graphData3 = {0, 20, 40, 30, 50, 10, 40, 60, 40, 20, 40, 30, 50, 20, 30,
                      0, 20, 40, 30, 20, 10, 30, 50, 40, 20, 40, 60, 80, 50};


// 그래프 데이터 합계 계산 함수 (부분합 지원)
float calculateGraphSum(float[] data, int length) {
    float sum = 0;
    for (int i = 0; i < length && i < data.length; i++) { 
        sum += data[i];
    }
    return (sum * 100) / 30.0; // 합계에 100을 곱하고 30으로 나눔
}
void drawDynamicProgressBar(float x, float y, float width, float height, float[] data, int graphType) {
    // 데이터 합계 계산
    float sum = 0;
    for (int i = 0; i < data.length; i++) {
        sum += data[i];
    }

    float maxSum = 1200; // 기준값 (40 * 30)
    float progressWidth = map(sum, 0, maxSum, 0, width); // 기본 프로그레스 바 길이 계산

    // 배경 바 그리기
    noStroke();
    fill(100); // 회색 배경 바
    rect(x, y, width, height);

    // 그래프 타입별 색상 지정
    color graphColor;
    if (graphType == 1) {
        graphColor = color(154, 172, 156); // #9AAC9C
    } else if (graphType == 2) {
        graphColor = color(255, 231, 152); // #FFE798
    } else if (graphType == 3) {
        graphColor = color(156, 165, 207); // #9CA5CF
    } else {
        graphColor = color(255); // 기본 흰색
    }

    // 초과 여부 확인
    if (sum <= maxSum) {
        // 합계가 1200 이하일 경우, 지정된 색상 출력
        fill(graphColor);
        rect(x, y, progressWidth, height);
    } else {
        // 합계가 1200을 초과하면, 초과 길이만큼 빨간색 바 추가
        float overWidth = map(sum - maxSum, 0, maxSum, 0, width); // 초과 길이 계산

        fill(graphColor); // 지정된 색상
        rect(x, y, width, height); // 전체 바 채움

        fill(255, 0, 0); // 빨간색 바
        rect(x + (width - overWidth), y, overWidth, height); // 초과된 부분만 빨간색 출력
    }
}



void drawGraph30(float x, float y, float width, float height, int graphType, int length) {
    noFill();
    stroke(255);
    strokeWeight(3);

    float[] data;

    // 그래프 타입에 따라 데이터 배열 선택
    if (graphType == 0) {
        data = new float[] {0, 10, 20, 30, 40, 50, 40, 30, 20, 10, 20, 40, 50, 40, 20,
                            0, 10, 20, 30, 40, 50, 40, 30, 20, 10, 20, 40, 50, 30};
    } else if (graphType == 1) {
        data = new float[] {0, 10, 9, 30, 40, 50, 45, 10, 25, 15, 25, 30, 55, 45, 35,
                            15, 35, 25, 10, 50, 55, 40, 30, 20, 20, 25, 45, 55, 35};
    } else if (graphType == 2) {
        data = new float[] {0, 20, 30, 60, 80, 40, 50, 30, 40, 20, 40, 60, 50, 70, 30,
                            20, 20, 40, 60, 80, 40, 30, 20, 40, 20, 40, 60, 40, 50};
    } else {
        println("Invalid graph type");
        return;
    }

    // 그래프 길이 조절
    int drawLength = min(length, data.length);

    // 그래프 그리기
    beginShape();
    for (int i = 0; i < drawLength; i++) {
        float px = x + map(i, 0, drawLength - 1, 0, width); // X 좌표 매핑
        float py = y + map(data[i], 0, 100, height, 0);     // Y 좌표 매핑 (반전)
        vertex(px, py);
    }
    endShape();

    noStroke();

    // 프로그레스 바 그리기
    float progressBarY = y + height + 10; // 프로그레스 바 Y 위치
    float progressBarWidth = map(drawLength, 0, data.length, 0, width); // 길이에 따라 늘어남

    fill(255); // 흰색으로 프로그레스 바 채우기
    rect(x, progressBarY, progressBarWidth, 5); // 프로그레스 바 출력
}

void drawCostMonthText(float x, float y, float value) {
    fill(255); // 흰색 텍스트
    textSize(14);
    textAlign(LEFT, CENTER);
    text(int(value) + "원", x, y); // 정수로 변환하고 원 단위 출력
}
void drawProgressBar(float x, float y, float width, int dataLength) {
    float maxLength = 30.0; // 최대 길이
    float progressWidth = map(dataLength, 0, maxLength, 0, width+45); // 길이 비례 계산

    // 프로그레스 바 그리기
    noStroke();
    fill(255); // 흰색
    rect(x, y, progressWidth, 5); // 동적으로 계산된 길이
}
void drawNewProgressBar(float x, float y, float width, int progressValue) {
    float maxLength = 30.0; // 최대 값
    float progressWidth = map(progressValue, 0, maxLength, 0, width); // 값에 따른 길이 비례 계산

    // 프로그레스 바 스타일
    noStroke();
    fill(100); // 배경 바 색상
    rect(x, y, width, 8); // 전체 배경 바 출력

    fill(255); // 프로그레스 바 색상 (흰색)
    rect(x, y, progressWidth, 8); // 동적으로 계산된 길이로 바 출력
}
int dataLengthForProgress(int costIndex) {
    if (costIndex == 0) return graphData1.length;
    if (costIndex == 1) return graphData2.length;
    if (costIndex == 2) return graphData3.length;
    return 0; // Cost4의 경우 데이터 없음
}

// 전역 변수로 선언
int graphLength;

void drawCostImageWithGraph(float x, float panelY, int costIndex) {
    float costX = x + 30;
    float costY = panelY + 110;

    // Cost4만 위치를 조정
    if (costIndex == 3) {
        costY += 20; // Cost4 위치 조정
        drawScaledImage(costX, costY, costImages[costIndex], 0.9);

        // Cost4 프로그레스 바 위치 오프셋
        float progressBarX = costX + 40; // X 위치 조정
        float progressBarY = costY + 150; // Y 위치 조정
        drawProgressBar(progressBarX, progressBarY, 320, 20);

        // *** 추가된 작대기(라인) *** etc
        stroke(255); // 라인 색상 (빨간색)
        strokeWeight(5);   // 라인 두께
        float lineY = progressBarY - 13; // 프로그레스바 위쪽에 선 추가
        line(progressBarX, lineY, progressBarX + 200, lineY); // 라인 시작~끝 X 좌표
        noStroke(); // 기존 스타일로 복원
    } else {
        if (costIndex == 2) {
            costY += 6; // Cost3 위치 조정
        }

        drawScaledImage(costX, costY, costImages[costIndex], 0.9);

        // 숫자 및 단위 텍스트
        float textX = x + 20;
        float textY = panelY + 15;
        drawMonitoringText(textX, textY, 324, 50);

        // 그래프 데이터 및 위치 설정
        float graphX = costX + 40;
        float graphY = costY + 80;
        float graphWidth = 200;
        float graphHeight = 30;

        float monthCost;

        // 그래프 그리기 및 데이터 합계
        if (costIndex == 0) {
            graphLength = 30; 
            drawGraph30(graphX, graphY, graphWidth, graphHeight, graphData1, graphLength);
            monthCost = calculateGraphSum(graphData1, graphLength);
        } else if (costIndex == 1) {
          //시연때는 이걸 건들이자
            graphLength = 30; 
            drawGraph30(graphX, graphY, graphWidth, graphHeight, graphData2, graphLength);
            monthCost = calculateGraphSum(graphData2, graphLength);
        } else {
            graphLength = 30; 
            drawGraph30(graphX, graphY, graphWidth, graphHeight, graphData3, graphLength);
            monthCost = calculateGraphSum(graphData3, graphLength);
        }
        // Cost별 동적 프로그레스 바 추가
       if (costIndex == 0) {
    drawDynamicProgressBar(graphX-3, graphY + graphHeight + 46, graphWidth+44, 5, graphData1, 1);
} else if (costIndex == 1) {
    drawDynamicProgressBar(graphX-3, graphY + graphHeight + 46, graphWidth+44, 5, graphData2, 2);
} else if (costIndex == 2) {
    drawDynamicProgressBar(graphX-3, graphY + graphHeight + 40, graphWidth+44, 5, graphData3, 3);
}


         // costMonth 원 위치 오프셋 조정
    float costMonthX = graphX + graphWidth - 9; // 기본 X 위치
    float costMonthY = graphY - 32; // 기본 Y 위치

    if (costIndex == 1) costMonthY += 0; // Cost2 원 위치 미세 조정
    if (costIndex == 2) {
        costMonthX += 10; // Cost3 X 위치 왼쪽으로 이동
        costMonthY += -7; // Cost3 Y 위치 위로 이동
    }

    drawCostMonthText(costMonthX, costMonthY, monthCost);

         // Cost별 프로그레스 바 위치 오프셋
        float progressBarX = costX + 37; // X 위치 조정
        float progressBarY = costY + graphHeight + 10; // 기본 Y 위치
        if (costIndex == 0) progressBarY += 130; // Cost2 위치 미세 조정
        if (costIndex == 1) progressBarY += 130; // Cost2 위치 미세 조정
        if (costIndex == 2) {
          progressBarY += 125; // Cost3 위치 미세 조정
        }

        drawProgressBar(progressBarX, progressBarY, graphWidth, graphLength);
    }

    // 텍스트 버튼 출력 (Cost4 포함)
    float panelWidth = 324;
    float buttonBaseY = panelY + 160;
    drawSubButtons(x + 23, buttonBaseY, panelWidth, 50);
}




void drawGraph30(float x, float y, float width, float height, float[] data, int maxLength) {
    noFill();
    stroke(255);
    strokeWeight(3);

    beginShape();
    for (int i = 0; i < min(data.length, maxLength); i++) { // 최대 길이만큼만 사용
        float px = x + map(i, 0, maxLength - 1, 0, width); // X 좌표 매핑
        float py = y + map(data[i], 0, 100, height, 0);    // Y 좌표 매핑 (반전)
        vertex(px, py);
    }
    endShape();
    noStroke();
}


void drawScaledImage(float x, float y, PImage img, float scale) {
  if (img == null) return;

  // 원본 비율을 유지하면서 크기 조정
  float panelWidth = img.width * scale;  // 폭을 scale로 조정
  float panelHeight = img.height * scale; // 높이를 scale로 조정
  image(img, x, y, panelWidth, panelHeight); // 이미지 출력
}

void loadMonitoringAndCostImages() {
  monitoringImg = loadImage("../data/monitoring.png");
  costImages[0] = loadImage("../data/Cost21.png");
  costImages[1] = loadImage("../data/Cost22.png");
  costImages[2] = loadImage("../data/Cost23.png");
  costImages[3] = loadImage("../data/Cost24.png");
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

        // 모니터링 텍스트 (숫자와 단위)
        float textX = x + 20;
        float textY = panelY + 15;
        drawMonitoringText(textX, textY, 324, 50);

        // Cost 패널 이미지 및 그래프
        drawCostImageWithGraph(x, panelY, currentCostImageIndex[i]);

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

        fill(255); // 흰색 텍스트
        text(panelText[i][0], x - 10, y + 23); // 숫자 출력
        textSize(20);
        text(panelText[i][1], x + 15, y + 26); // 단위 출력
        textSize(28); // 크기 복원
    }
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

//이미지 출력띠
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


void changePlacePressed(float baseYOffset) {
  float yOffset = baseYOffset; // 꺾쇠 버튼의 Y위치

  // 왼쪽 버튼 클릭 감지
  if (mouseX > 0 && mouseX < 50 &&
      mouseY > yOffset - 50 && mouseY < yOffset + 50 &&
      currentShopIndex > 0) {
    currentShopIndex--;
    updateGraphDataForShop();
  }

  // 오른쪽 버튼 클릭 감지
  if (mouseX > width - 50 && mouseX < width &&
      mouseY > yOffset - 50 && mouseY < yOffset + 50 &&
      currentShopIndex < shops.length - 1) {
    currentShopIndex++;
    updateGraphDataForShop();
  }

  targetSwipeX = -currentShopIndex * width;
}
