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
