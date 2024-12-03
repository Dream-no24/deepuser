PFont font;
PImage img;

boolean isLocked = false;  // 세로 스크롤 잠금 여부
float pos = 0, npos = 0;   // 현재 세로 위치와 목표 위치

void setup() {
  size(360, 800);
  background(50, 50, 50);
  img = loadImage("../data/deepuser.png");
  font = createFont("../data/AppleSDGothicNeo.ttc", 14);
  textFont(font);
}

void draw() {
  background(50, 50, 50);
  image(img, 0, 0, width, height);

  // 세로 스크롤 위치 보정
  npos = constrain(npos, -1400, 0);
  pos += (npos - pos) * 0.1;

  pushMatrix();
  translate(0, pos);

  // 패널들 그리기
  drawInfoPanel();
  drawIssueAndSchedulePanels();
  drawMonitoringAndCostPanel(); // MonitoringAndCostPanel의 함수 호출
  drawCalendarPanel();
  drawTablePanel();
  popMatrix();
}

// 마우스 클릭 이벤트
void mousePressed() {
  if (!handleSwipe(mouseX, mouseY)) { // 스와이프가 아닌 경우 세로 스크롤
    isLocked = true;
  }
}

// 마우스 드래그 이벤트
void mouseDragged(MouseEvent event) {
  if (isSwipeActive()) { // 스와이프 중인 경우
    handleSwipeDragged(event);
  } else if (isLocked) {
    npos += mouseY - pmouseY; // 세로 스크롤 목표 위치 변경
  }
}

// 마우스 릴리즈 이벤트
void mouseReleased() {
  if (isSwipeActive()) {
    handleSwipeReleased();
  } else {
    isLocked = false;
  }
}

void drawInfoPanel() {
  fill(255, 255, 255, 200);
  noStroke();
  rect(10, 10, 340, 180, 20);  

  fill(255);
  ellipse(72, 72, 100, 100);


  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Today", 70, 52);
  textSize(60);
  text("4", 70, 88);

  
  textSize(14);
  text("이번 달 총", 210, 35);
  text("1년 간 총", 210, 55);
  textSize(18);
  text("79", 285, 35);
  text("683", 275, 55);
  textSize(15);
  text("개비", 310, 35);
  text("개비", 310, 55);

  fill(100);
  textSize(12);
  text("이렇게 살다간...", 290, 90);
  
  fill(0);
  textSize(14);
  text("1년간 폐에 쌓인 유독물질 12.5g", 240, 110);
  
  fill(240);
  rect(30, 160, 300, 10, 5);
  fill(100);
  rect(30, 160, 220, 10, 5);
  
  fill(0);
  textSize(12);
  text("현재 목표: 7개 / day", 80, 145);
  text("다음 목표: 6개 / day", 280, 145);
}

void drawIssueAndSchedulePanels() {
  float panelWidth = (340 - 20) / 2;
  float panelSpacing = 20;
  
  textAlign(LEFT, CENTER);
  fill(255, 255, 255, 230);
  rect(10, 210, panelWidth, 160, 20);
  fill(0);
  textSize(16);
  text("Issues", 20, 240);
  textSize(14);
  String[] issues = {"개포동 컨테이너", "천안시 페터널", "남현동 컨테이너"};
  for (int i = 0; i < 3; i++) {
    fill(0);
    float y = 265 + i * 23; 
    text(issues[i], 20, y);
    fill(150);
    ellipse(140, y, 20, 20); 
    textAlign(CENTER, CENTER); 
    fill(255, 255, 255);
    text(str(i + 1), 140, y); 
    textAlign(LEFT, CENTER);
  }



  fill(0, 0, 0, 140);
  noStroke();
  rect(10 + panelWidth + panelSpacing, 210, panelWidth, 160, 20);
  
  fill(255, 255, 255, 30);
  ellipse(35 + panelWidth + panelSpacing, 235, 40, 40);
  
  fill(255);
  rect(25 + panelWidth + panelSpacing, 222, 5, 5, 2);
  rect(25 + panelWidth + panelSpacing, 230, 20, 2, 2);
  rect(25 + panelWidth + panelSpacing, 235, 20, 2, 2);
  rect(25 + panelWidth + panelSpacing, 240, 20, 2, 2);

  
  fill(255);
  textSize(20);
  text("10월 17일", 60 + panelWidth + panelSpacing, 235);
  
  textSize(14);
  fill(255, 100, 100);
  ellipse(25 + panelWidth + panelSpacing, 265, 8, 8);
  text("미팅 11:00", 35 + panelWidth + panelSpacing, 265);
  textSize(10);
  fill(200);
  text("GS 담당자 미팅", 35 + panelWidth + panelSpacing, 280);

  fill(100, 200, 255);
  ellipse(25 + panelWidth + panelSpacing, 295, 8, 8);
  textSize(14);
  text("점검 13:00", 35 + panelWidth + panelSpacing, 295);
  textSize(10);
  fill(200);
  text("남현동 컨테이너 설비 점검", 35 + panelWidth + panelSpacing, 310);

  fill(100, 255, 100);
  ellipse(25 + panelWidth + panelSpacing, 325, 8, 8);
  textSize(14);
  text("납품 15:00", 35 + panelWidth + panelSpacing, 325);
  textSize(10);
  fill(200);
  text("페터널 - emart 천안점 납품", 35 + panelWidth + panelSpacing, 340);
  
  /*
  fill(255, 200, 100);
  ellipse(25 + panelWidth + panelSpacing, 355, 8, 8);
  textSize(14);
  text("일상 17:00", 35 + panelWidth + panelSpacing, 355);
  textSize(10);
  fill(200);
  text("디도재즈라운지 예약 @수빈", 35 + panelWidth + panelSpacing, 370);
  */
}

// 스와이프 관련 변수
float swipeX = 0;  // 현재 스와이프 위치
float targetSwipeX = 0;  // 목표 스와이프 위치
boolean swipeActive = false;  // 스와이프 활성화 여부
float swipeSensitivity = 0.1;  // 스와이프 감도
String[] shops = {
  "천안시 페터널\n습도 52%, 온도 27도, 조도 55lx, 물 2.5L",
  "개포동 컨테이너\n습도 48%, 온도 26도, 조도 60lx, 물 3.0L",
  "남현동 컨테이너\n습도 55%, 온도 28도, 조도 50lx, 물 2.8L"
};

// 패널 그리기 함수
void drawMonitoringAndCostPanel() {
  // 부드러운 스와이프 처리
  swipeX += (targetSwipeX - swipeX) * swipeSensitivity;

  pushMatrix();
  translate(swipeX, 0); // 전체 패널 이동

  for (int i = 0; i < shops.length; i++) {
    float x = i * width; // 각 점포의 x 좌표

    // 큰 박스 (투명한 배경)
    fill(0, 0, 0, 150);
    noStroke();
    rect(10 + x, 400, 340, 350, 20); // 반투명 검은 박스

    // 모니터링 박스
    drawPanel(x, 410, "모니터링", shops[i], 120);

    // 코스트 박스 (세로 길이 더 길게 설정)
    drawPanel(x, 550, "코스트 정보", "매출 10000원 당 4294원", 180);
  }

  popMatrix();

  // 스와이프 경계 제한
  float minSwipeX = -(shops.length - 1) * width;
  float maxSwipeX = 0;
  targetSwipeX = constrain(targetSwipeX, minSwipeX, maxSwipeX);
}

// 패널 내용 출력 함수
void drawPanel(float offsetX, float y, String title, String content, float panelHeight) {
  float panelWidth = 300; // 하얀 박스의 가로 길이
  fill(255, 255, 255, 230);
  rect(30 + offsetX, y, panelWidth, panelHeight, 20); // 하얀 박스 (세로 길이 조정 가능)

  fill(0);
  textSize(16);
  text(title, 40 + offsetX, y + 20); // 제목 텍스트
  textSize(11);
  text(content, 43 + offsetX, y + 40); // 내용 텍스트
}

// 스와이프 활성화 여부 확인
boolean isSwipeActive() {
  return swipeActive;
}

// 스와이프 핸들링 함수
boolean handleSwipe(float mouseX, float mouseY) {
  if (mouseY > 400 && mouseY < 700) { // 스와이프 활성화 영역 확장
    swipeActive = true;
    return true;
  }
  return false;
}

void handleSwipeDragged(MouseEvent event) {
  if (swipeActive) {
    targetSwipeX += mouseX - pmouseX; // 목표 스와이프 위치 변경
  }
}

void handleSwipeReleased() {
  if (swipeActive) {
    // 가장 가까운 점포로 스냅
    int closestIndex = round(targetSwipeX / -width);
    targetSwipeX = -closestIndex * width;
    swipeActive = false;
  }
}

void drawCalendarPanel() {
  // 캘린더 패널
  fill(0, 0, 0, 160); // 패널 배경 색
  rect(10, 800, 340, 340, 20); // 둥근 모서리 패널

  // '10월' 텍스트
  fill(255); // 흰색 텍스트
  textSize(18);
  textAlign(CENTER, CENTER);
  text("10월", 90, 830); // 중앙에 정렬

  // 요일 텍스트
  textSize(12);
  for (int i = 0; i < 7; i++) {
    if (i == 0) fill(200); // 일요일 (회색)
    else if (i == 6) fill(180); // 토요일 (연한 회색)
    else fill(255); // 평일 (흰색)
    textAlign(RIGHT, CENTER); // 오른쪽 정렬
    text(getDayName(i), 325 - (6 - i) * 45, 860); // 요일 배치
  }

  // 날짜 그리기
  drawCalendarDates();
}

void drawCalendarDates() {
  textSize(12); // 날짜 텍스트 크기 설정
  for (int i = 1; i <= 31; i++) {
    int x = 325- ((6 - (i + 6) % 7) * 45); // x 좌표 (요일 간격 조정, 10월 1일이 일요일 기준)
    int y = 870 + ((i + 6) / 7) * 35; // y 좌표 (날짜 간격 조정)

    if ((i + 6) % 7 == 0) fill(200); // 일요일 (회색)
    else if ((i + 6) % 7 == 6) fill(180); // 토요일 (연한 회색)
    else fill(255); // 평일 (흰색)
    textAlign(RIGHT, CENTER); // 오른쪽 정렬
    text(i, x, y); // 날짜 출력
  }
}

String getDayName(int day) {
  // 요일 이름 반환
  String[] days = {"일", "월", "화", "수", "목", "금", "토"};
  return days[day];
}

String[] headers = {"날짜", "납품처", "품목 (지점)", "납품", "재고"};
String[][] data = {
  {"11/02", "emart 강남점", "배추 (남현)", "120", "80"},
  {"11/02", "emart 강남점", "토마토 (천안)", "120", "120"},
  {"11/24", "롯데마트 성수점", "토마토 (천안)", "80", "110"},
  {"11/27", "롯데마트 강남점", "로즈마리 (남현)", "120", "60"},
  {"11/28", "emart 개포점", "로즈마리 (남현)", "200", "140"},
  {"11/30", "롯데마트 과천점", "로즈마리 (남현)", "190", "80"}
};

float tableStartY = 1200; // 테이블의 시작 Y 좌표
float tableHeight = 300; // 테이블 높이
float rowHeight = 35; // 각 행 높이
float headerHeight = 50; // 헤더 높이
float scrollOffset = 0; // 세로 스크롤 오프셋

void drawTablePanel() {
  float startX = 10; // 테이블 시작 X 좌표
  float tableWidth = width - 2 * startX; // 테이블 가로 길이

  // 테이블 전체 배경
  fill(0, 0, 0, 160); // 반투명 검은 배경
  rect(startX, tableStartY, tableWidth, tableHeight, 20);

  // 헤더
  fill(255); // 흰색 텍스트
  textSize(12); // 헤더 글씨 크기
  textAlign(CENTER, CENTER);
  for (int i = 0; i < headers.length; i++) {
    float colWidth = tableWidth / headers.length;
    text(headers[i], startX + i * colWidth + colWidth / 2, tableStartY + headerHeight / 2);
  }

  // 데이터 클리핑
  clip(startX, tableStartY + headerHeight, tableWidth, tableHeight - headerHeight);

  // 데이터 출력
  for (int i = 0; i < data.length; i++) {
    float y = tableStartY + headerHeight + i * rowHeight - scrollOffset;
    if (y + rowHeight > tableStartY + headerHeight && y < tableStartY + tableHeight) {
      fill(0, 0, 0, 160); // 반투명 검은 배경
      rect(startX, y, tableWidth, rowHeight);

      fill(255); // 데이터 텍스트 흰색
      textSize(10); // 데이터 글씨 크기 축소
      textAlign(CENTER, CENTER);
      for (int j = 0; j < data[i].length; j++) {
        float colWidth = tableWidth / headers.length;
        text(data[i][j], startX + j * colWidth + colWidth / 2, y + rowHeight / 2);
      }
    }
  }
  noClip(); // 클리핑 해제
}
