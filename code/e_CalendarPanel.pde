String month = "12월"; // 달 이름 고정
String[] daysOfWeek = {"일", "월", "화", "수", "목", "금", "토"}; // 요일 배열
float baseYOffset = 0; // 화면 스크롤 위치를 나타내는 Y 오프셋 변수

// 캘린더 패널 그리기 함수
void drawCalendarPanel(float baseYOffset, int[][] eventData) {
  pushMatrix();

  float panelY = baseYOffset;

  // 달 패널 배경
  fill(0, 0, 0, 160);
  rect(22.5, panelY, 315, 290, 20);

  // 달 이름 출력
  fill(255);
  textSize(18);
  textAlign(CENTER, CENTER);
  text(month, width / 2 - 90, panelY + 25);

  // 요일 출력
  drawDaysOfWeek(panelY + 60);

  // 날짜 및 이벤트 출력
  drawCalendarDates(panelY, eventData);
  popMatrix();
}

// 요일 출력 함수
void drawDaysOfWeek(float yOffset) {
  textSize(14);
  textAlign(CENTER, CENTER);
  for (int i = 0; i < daysOfWeek.length; i++) {
    int x = 55 + i * 42; // 각 요일의 X 좌표
    if (i == 0) fill(160, 160, 160); // 일요일 (회색)
    else if (i == 6) fill(160, 160, 160); // 토요일 (회색)
    else fill(255); // 평일 (흰색)
    text(daysOfWeek[i], x, yOffset);
  }
}

// 날짜 출력 함수
void drawCalendarDates(float panelY, int[][] eventData) {
  textSize(12);
  textAlign(CENTER, CENTER);
  for (int i = 1; i <= 31; i++) {
    int x = 55 + ((i + 6) % 7) * 42;
    int y = (int) (panelY + 50 + ((i + 6) / 7) * 38);

    if ((i + 6) % 7 == 0) fill(200);
    else if ((i + 6) % 7 == 6) fill(180);
    else fill(255);

    text(i, x, y);
    drawEventDots(i, x, y + 10, eventData);
  }
}

// 이벤트 점 출력 함수
void drawEventDots(int day, int x, int y, int[][] eventData) {
  int redDots = eventData[day - 1][0];
  int blueDots = eventData[day - 1][1];
  int yellowDots = eventData[day - 1][2];

  // 빨간색 점 출력
  fill(255, 100, 100);
  for (int i = 0; i < redDots; i++) {
    ellipse(x - 8 + i * 5, y, 4, 4);
  }

  // 파란색 점 출력
  fill(100, 200, 255);
  for (int i = 0; i < blueDots; i++) {
    ellipse(x - 8 + redDots * 5 + i * 5, y, 4, 4);
  }

  // 노란색 점 출력
  fill(255, 220, 100);
  for (int i = 0; i < yellowDots; i++) {
    ellipse(x - 8 + (redDots + blueDots) * 5 + i * 5, y, 4, 4);
  }
}

// 이벤트 데이터 초기화
int[][] initializeEventMap() {
  int[][] eventData = new int[31][3];
  eventData[0] = new int[]{1, 2, 1};  // 1일
  eventData[1] = new int[]{2, 1, 1};  // 2일
  eventData[2] = new int[]{1, 1, 2};  // 3일
  eventData[3] = new int[]{3, 0, 1};  // 4일
  eventData[4] = new int[]{2, 2, 0};  // 5일
  eventData[5] = new int[]{1, 3, 0};  // 6일
  eventData[6] = new int[]{0, 4, 0};  // 7일
  eventData[7] = new int[]{2, 1, 1};  // 8일
  eventData[8] = new int[]{1, 2, 1};  // 9일
  eventData[9] = new int[]{3, 1, 0};  // 10일
  eventData[10] = new int[]{0, 2, 2}; // 11일
  eventData[11] = new int[]{2, 0, 2}; // 12일
  eventData[12] = new int[]{1, 1, 2}; // 13일
  eventData[13] = new int[]{4, 0, 0}; // 14일
  eventData[14] = new int[]{2, 2, 0}; // 15일
  eventData[15] = new int[]{3, 1, 0}; // 16일
  eventData[16] = new int[]{1, 3, 0}; // 17일
  eventData[17] = new int[]{2, 0, 2}; // 18일
  eventData[18] = new int[]{1, 2, 1}; // 19일
  eventData[19] = new int[]{0, 4, 0}; // 20일
  eventData[20] = new int[]{2, 1, 1}; // 21일
  eventData[21] = new int[]{3, 0, 1}; // 22일
  eventData[22] = new int[]{0, 3, 1}; // 23일
  eventData[23] = new int[]{1, 1, 2}; // 24일
  eventData[24] = new int[]{2, 2, 0}; // 25일
  eventData[25] = new int[]{1, 3, 0}; // 26일
  eventData[26] = new int[]{0, 2, 2}; // 27일
  eventData[27] = new int[]{4, 0, 0}; // 28일
  eventData[28] = new int[]{2, 1, 1}; // 29일
  eventData[29] = new int[]{3, 0, 1}; // 30일
  eventData[30] = new int[]{1, 2, 1}; // 31일
  return eventData;
}
