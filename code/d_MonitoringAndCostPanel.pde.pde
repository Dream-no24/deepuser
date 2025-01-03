int dayOffset = 0; // 날짜를 올리는 오프셋 값
int costThreshold = 2700; // 1500 // 날짜를 올리는 오프셋 값


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

// 점포별 텍스트 값과 단위 정의
String[][][] shopPanelTexts = {
  {{" 52", " %"}, {"  27", "°"}, {"55", "lx"}, {"2.5", "h"}}, // 점포 1 데이터
  {{" 47", " %"}, {"  30", "°"}, {"60", "lx"}, {"1.5", "h"}}, // 점포 2 데이터
  {{" 50", " %"}, {"  25", "°"}, {"50", "lx"}, {"2.0", "h"}}, // 점포 3 데이터
  {{" 48", " %"}, {"  22", "°"}, {"55", "lx"}, {"2.5", "h"}}  // 점포 4 데이터
};
String[][] panelText = shopPanelTexts[currentShopIndex];


float[][] shopGraphData1 = new float[4][30]; // 그래프 데이터 1
float[][] shopGraphData2 = new float[4][30]; // 그래프 데이터 2
float[][] shopGraphData3 = new float[4][30]; // 그래프 데이터 3
void generateRandomGraphData(float[] data, int minVal, int maxVal) {
  int length = 30; // 고정된 길이
  for (int i = 0; i < length; i++) {
    data[i] = random(minVal, maxVal); // 지정된 범위 내 랜덤 값 생성
  }
}


void updateGraphDataForShop() {
  if (currentShopIndex >= 0 && currentShopIndex < shopGraphData1.length) {
    println("Updating graph data for shop: " + currentShopIndex);
    println("Shop Graph Data1: " + Arrays.toString(shopGraphData1[currentShopIndex]));
    println("Shop Graph Data2: " + Arrays.toString(shopGraphData2[currentShopIndex]));
    println("Shop Graph Data3: " + Arrays.toString(shopGraphData3[currentShopIndex]));

    int minLength = min(shopGraphData1[currentShopIndex].length, graphData1.length);
    for (int i = 0; i < minLength; i++) {
      graphData1[i] = shopGraphData1[currentShopIndex][i];
      graphData2[i] = shopGraphData2[currentShopIndex][i];
      graphData3[i] = shopGraphData3[currentShopIndex][i];
    }

    println("Updated Graph Data1: " + Arrays.toString(graphData1));
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

    float maxSum = costThreshold; 
    float progressWidth = map(sum, 0, maxSum, 0, width); // 기본 프로그레스 바 길이 계산

    // 배경 바 그리기
    noStroke();
    fill(100); // 회색 배경 바
    rect(x, y, width, height, height/2);

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
        // 합계가 2100 이하일 경우, 지정된 색상 출력
        fill(graphColor);
        rect(x, y, progressWidth, height, height / 2);
    } else {
        // 합계가 2100을 초과하면, 초과 길이만큼 빨간색 바 추가
        float overWidth = map(sum - maxSum, 0, maxSum, 0, width); // 초과 길이 계산

        fill(graphColor); // 지정된 색상
        rect(x, y, width, height, height / 2); // 전체 바 채움

        fill(255, 0, 0); // 빨간색 바
        rect(x + (width - overWidth), y, overWidth, height, height / 2); // 초과된 부분만 빨간색 출력
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
    textSize(20);
    textAlign(LEFT, CENTER);
    text(int(value) + "원", x, y); // 정수로 변환하고 원 단위 출력
}
void drawProgressBar(float x, float y, float width, int dataLength) {
    int today = day() + dayOffset; // 오늘 날짜 가져오기
    int maxDays = 30; // 최대 일수
    float progressRatio = constrain((float) today / maxDays, 0, 1); // 오늘 날짜 비율 계산 (0 ~ 1)
    float progressWidth = progressRatio * (width+30); // 비율에 따른 프로그레스 바 너비 계산

    // 프로그레스 바 그리기
    noStroke();
    fill(255); // 흰색
    rect(x, y, progressWidth, 5, 2.5); // 동적으로 계산된 길이
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

int[] getCurrentDateInfo() {
    java.util.Calendar calendar = java.util.Calendar.getInstance();
    
    
    
    // 현재 날짜에 오프셋 추가
    calendar.add(java.util.Calendar.DAY_OF_MONTH, dayOffset);
    
    int year = calendar.get(java.util.Calendar.YEAR); // 연도
    int month = calendar.get(java.util.Calendar.MONTH) + 1; // 월 (0부터 시작하므로 +1)
    int day = calendar.get(java.util.Calendar.DAY_OF_MONTH); // 일
    return new int[]{year, month, day};
}

int getGraphLengthBasedOnDate() {
    int day = getCurrentDateInfo()[2]; // 현재 날짜의 '일' 가져오기
    int graphLength = constrain(day, 1, 30); // 1 ~ 30 범위로 제한
    graphLength = (int) (graphLength * 1.3); // 1.3배 적용
    return constrain(graphLength, 1, 30); // 1 ~ 30 범위로 재제한
}

// 데이터 생성 범위를 날짜에 따라 조정
void generateRandomGraphDataBasedOnDate(float[] data) {
    int[] dateInfo = getCurrentDateInfo();
    int day = dateInfo[2];
    int minVal = day * 2; // 최소값: 날짜에 따라 동적으로 변경
    int maxVal = minVal + 50; // 최대값: 최소값 + 50
    generateRandomGraphData(data, minVal, maxVal); // 기존 함수 호출
}

// 초기화 시 날짜 기반 데이터 생성
void initializeGraphData() {
    for (int i = 0; i < 4; i++) { // 점포 4개
        generateRandomGraphDataBasedOnDate(shopGraphData1[i]);
        generateRandomGraphDataBasedOnDate(shopGraphData2[i]);
        generateRandomGraphDataBasedOnDate(shopGraphData3[i]);
    }
}
void initializeGraphData1() {
  for (int i = 0; i < 4; i++) { // 점포 4개
    generateRandomGraphData(shopGraphData1[i], 20, 80); // 그래프 1 범위: 20 ~ 80
    generateRandomGraphData(shopGraphData2[i], 10, 60); // 그래프 2 범위: 10 ~ 60
    generateRandomGraphData(shopGraphData3[i], 0, 50);  // 그래프 3 범위: 0 ~ 50
  }
} 

float getCost4LineLength() {
    int day = getCurrentDateInfo()[2]; // 현재 날짜의 '일' 가져오기
    return map(day, 1, 30, 0, 240); // 최소 10, 최대 200으로 매핑
}

void drawCostImageWithGraph(float x, float panelY, int costIndex) {
    float costX = x + 30;
    float costY = panelY + 110;

    // Cost4만 위치를 조정
    if (costIndex == 3) {
        costY += 20; // Cost4 위치 조정
        drawScaledImage(costX, costY, costImages[costIndex], 0.9);

        // Cost4 프로그레스 바 위치 오프셋
        float progressBarX = costX + 30; // X 위치 조정
        float progressBarY = costY + 151; // Y 위치 조정

        // *** 추가된 작대기(라인) *** etc
        stroke(255); // 라인 색상
        strokeWeight(5);   // 라인 두께
        strokeCap(ROUND);
        float lineLength = getCost4LineLength(); // 날짜 기반 선 길이 계산
        float lineY = progressBarY - 13; // 프로그레스바 위쪽에 선 추가
        line(progressBarX, lineY, progressBarX + lineLength - 20, lineY); // 라인 시작~끝 X 좌표
        line(progressBarX, progressBarY, progressBarX + lineLength-5, progressBarY); // 라인 시작~끝 X 좌표
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

        float monthCost = 0; // 기본값 0으로 초기화

// 날짜 기반 그래프 길이
graphLength = getGraphLengthBasedOnDate();

// Cost별 그래프 출력
if (costIndex == 0) {
    drawGraph30(graphX-11, graphY, graphWidth-60, graphHeight, graphData1, graphLength);
    monthCost = calculateGraphSum(graphData1, graphLength); // monthCost에 결과 저장
} else if (costIndex == 1) {
    drawGraph30(graphX-11, graphY, graphWidth-60, graphHeight, graphData2, graphLength);
    monthCost = calculateGraphSum(graphData2, graphLength); // monthCost에 결과 저장
} else {
    drawGraph30(graphX-11, graphY, graphWidth-60, graphHeight, graphData3, graphLength);
    monthCost = calculateGraphSum(graphData3, graphLength); // monthCost에 결과 저장
}

// 날짜 기반 동적 프로그레스 바 추가
if (costIndex == 0) {
    drawDynamicProgressBar(graphX - 9, graphY + graphHeight + 48, graphWidth + 55, 6, graphData1, 1);
} else if (costIndex == 1) {
    drawDynamicProgressBar(graphX - 9, graphY + graphHeight + 48, graphWidth + 55, 6, graphData2, 2);
} else if (costIndex == 2) {
    drawDynamicProgressBar(graphX - 9, graphY + graphHeight + 42, graphWidth + 55, 6, graphData3, 3);
}

// costMonth 원 위치 오프셋 조정
float costMonthX = graphX + graphWidth - 9; // 기본 X 위치
float costMonthY = graphY - 32; // 기본 Y 위치

if (costIndex == 1) costMonthY += 0; // Cost2 원 위치 미세 조정
if (costIndex == 2) {
    costMonthX += 10; // Cost3 X 위치 왼쪽으로 이동
    costMonthY += -7; // Cost3 Y 위치 위로 이동
}

// monthCost 값 출력 (계산된 값을 사용)
drawCostMonthText(costMonthX-4, costMonthY-5, monthCost);


         // Cost별 프로그레스 바 위치 오프셋
        float progressBarX = costX + 37; // X 위치 조정
        float progressBarY = costY + graphHeight + 10; // 기본 Y 위치
        if (costIndex == 0) progressBarY += 130; // Cost2 위치 미세 조정
        if (costIndex == 1) progressBarY += 130; // Cost2 위치 미세 조정
        if (costIndex == 2) {
          progressBarY += 125; // Cost3 위치 미세 조정
        }

        drawProgressBar(progressBarX-5, progressBarY+2, graphWidth, graphLength);
    }

    // 텍스트 버튼 출력 (Cost4 포함)
    float panelWidth = 315;
    float buttonBaseY = panelY + 160;
    drawSubButtons(x + 23, buttonBaseY-70, panelWidth, 50, currentShopIndex); // shopIndex 추가

}




void drawGraph30(float x, float y, float totalWidth, float height, float[] data, int maxLength) {
    noFill();
    stroke(255);
    strokeWeight(3);
    
    // 현재 날짜에 기반한 너비 계산
    float adjustedWidth = map(maxLength, 1, 30, 0, totalWidth+45); // dAyOffset 비율 기반 너비

    beginShape();
    for (int i = 0; i < min(data.length, maxLength); i++) { // 최대 길이만큼만 사용
        float px = x + map(i, 0, maxLength - 1, 0, adjustedWidth); // X 좌표 매핑
        float py = y + map(data[i], 0, 100, height, 0);    // Y 좌표 매핑 (반전)
        vertex(px, py);
    }
    endShape();
    noStroke();
}


void drawScaledImage(float x, float y, PImage img, float scale) {
  if (img == null) return;

  // 원본 비율을 유지하면서 크기 조정
  float panelWidth = img.width * 0.934;  // 폭을 scale로 조정
  float panelHeight = img.height * 0.934; // 높이를 scale로 조정
  image(img, x-7, y-5, panelWidth, panelHeight); // 이미지 출력
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
        image(monitoringImg, x + 23.5, panelY + 10, 315, 100);

        // 모니터링 텍스트 (숫자와 단위)
        float textX = x + 20;
        float textY = panelY + 15;
        drawMonitoringText(textX, textY, 324, 50);

        // Cost 패널 이미지 및 그래프
        drawCostImageWithGraph(x, panelY, currentCostImageIndex[i]);

        
      // 점포 이름(박스 위 중앙)에 표시
      // ─────────────────────────────────────────────
      textAlign(CENTER, CENTER);
  
      // 현재 인덱스인 패널 → 흰색 / 양옆에 이전·다음 이름은 회색
      if (i == currentShopIndex) {
        // 현재 점포(흰색)
        textFont(boldFont);
        textSize(20);
        fill(255);
        text(shops[i], x + width/2, panelY - 20);
        textFont(regularFont);
  
        // 이전 점포(회색) - 있으면 표시
        if (i > 0) {
          textSize(12);
          fill(150);
          // 원하는 위치만큼 좌우 간격을 조절한다. 여기서는 -120 정도로 가정
          text(shops[i - 1], x + width/2 - 115, panelY - 17);
        }
  
        // 다음 점포(회색) - 있으면 표시
        if (i < shops.length - 1) {
          textSize(12);
          fill(150);
          // 여기서는 +120 정도로 가정
          text(shops[i + 1], x + width/2 + 115, panelY - 17);
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


int[][][] selectedSubButtonIndices = new int[4][4][3]; // 4개 점포, 각 점포당 4개 그룹, 3개의 버튼

void initializeButtonStates() {
  for (int shop = 0; shop < 4; shop++) {
    for (int group = 0; group < 4; group++) {
      selectedSubButtonIndices[shop][group][1] = 1; // 기본값은 '표준' 버튼 (1)
    }
  }
}

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
    
    // 점포별 텍스트 가져오기
    String[][] panelText = shopPanelTexts[currentShopIndex];

    // 숫자와 단위 출력
    for (int i = 0; i < panelText.length; i++) {
        float x = panelX + (i * sectionWidth) + sectionWidth / 2; // 중앙 정렬된 X 좌표
        float y = panelY + panelHeight / 2; // 패널 중앙 Y 좌표

        fill(255); // 흰색 텍스트
        text(panelText[i][0], x - 6, y + 23); // 숫자 출력
        textSize(20);
        text(panelText[i][1], x + 20, y + 26); // 단위 출력
        textSize(28); // 크기 복원
    }
}


void drawSubButtons(float panelX, float panelY, float panelWidth, float panelHeight, int shopIndex) {
  float sectionWidth = panelWidth / 4; // 각 그룹의 폭
  textAlign(CENTER, CENTER);

  for (int group = 0; group < 4; group++) { // 4개의 그룹 반복
    float groupX = panelX + (group * sectionWidth); // 그룹 시작 X 좌표
    float groupY = panelY; // 그룹 Y 위치
    float buttonSpacing = sectionWidth / 3; // 버튼 간 간격

    for (int i = 0; i < 3; i++) { // 각 그룹당 3개의 버튼
      float buttonX = groupX + (i * buttonSpacing) + buttonSpacing / 2;
      float buttonY = groupY;

      // 선택된 버튼 강조 처리
      textSize(selectedSubButtonIndices[shopIndex][group][i] == 1 ? 14 : 10);
      fill(selectedSubButtonIndices[shopIndex][group][i] == 1 ? color(255) : color(200));
      text(shopSubButtonTexts[shopIndex][group][i], buttonX, buttonY);
    }
  }
}

// 점포별로 그룹당 3개의 버튼 텍스트 저장
String[][][] shopSubButtonTexts = new String[4][4][3]; 
void initializeShopButtonTexts() {
  String[] defaultTexts = {"절약", "표준", "최적"};

  for (int shop = 0; shop < 4; shop++) { // 총 4개의 점포
    for (int group = 0; group < 4; group++) { // 각 점포당 4개의 그룹
      for (int i = 0; i < 3; i++) { // 각 그룹당 3개의 버튼
        shopSubButtonTexts[shop][group][i] = defaultTexts[i];
      }
    }
  }
}


// 전역 변수: 점포별 텍스트 상태를 저장하는 배열
String[][] shopTexts = new String[4][3]; // 점포 4개, 각 점포당 3개의 텍스트

int[] selectedTextIndex = {0, 0, 0, 0}; // 점포별 선택된 텍스트 인덱스 (0 ~ 2)

// 초기화 함수: 텍스트 초기화
void initializeShopTexts() {
  String[] initialTexts = {"절약", "표준", "최적"};
  for (int shop = 0; shop < shopTexts.length; shop++) {
    for (int i = 0; i < initialTexts.length; i++) {
      shopTexts[shop][i] = initialTexts[i];
    }
  }
}
void rotateTextGroup(int shopIndex, int group) {
  // 현재 점포의 그룹 상태 가져오기
  String[] texts = shopSubButtonTexts[shopIndex][group];
  String firstText = texts[0]; // 첫 번째 텍스트 저장

  // 텍스트를 왼쪽으로 회전
  for (int i = 0; i < texts.length - 1; i++) {
    texts[i] = texts[i + 1];
  }
  texts[texts.length - 1] = firstText; // 첫 번째 텍스트를 마지막으로 이동

  // 선택된 상태 강조: 중앙 텍스트 강조
  for (int i = 0; i < 3; i++) {
    selectedSubButtonIndices[shopIndex][group][i] = (i == 1) ? 1 : 0; // 중앙 텍스트 강조
  }
}


void rotateTexts(int group) {
  int[] buttonStates = selectedSubButtonIndices[currentShopIndex][group]; // 현재 점포의 그룹 상태 가져오기

  // 버튼 상태 회전 (예: 절약 -> 표준 -> 최적)
  int[] newStates = new int[3];
  for (int i = 0; i < 3; i++) {
    newStates[(i + 1) % 3] = buttonStates[i]; // 오른쪽으로 회전
  }

  // 회전된 상태를 현재 점포의 해당 그룹에 다시 할당
  for (int i = 0; i < 3; i++) {
    selectedSubButtonIndices[currentShopIndex][group][i] = newStates[i];
  }
}



//이미지 출력
void drawImagePanel(float offsetX, float offsetY, PImage img) {
    if (img == null) return; 
    float panelWidth = 315;
    float panelHeight = img.height * (panelWidth / img.width); // 비율에 맞게 높이 계산
    image(img, offsetX, offsetY, panelWidth, panelHeight);
  fill(255);
  textSize(11);
  textAlign(LEFT, TOP);
}

void drawSwipeButtons(float baseYOffset) {
  fill(255); 
  textFont(swipeButtonFont);
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
