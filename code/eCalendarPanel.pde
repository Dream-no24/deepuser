void drawCalendarPanel() {
  // 캘린더 패널
  fill(255, 255, 255, 230); // 패널 배경 색
  rect(10, 570, 340, 340, 20); // 둥근 모서리 패널
  fill(0); // 텍스트 색상
  textSize(16);
  text("10월", 20, 600); // 제목 텍스트
  textSize(12);
  text("일 월 화 수 목 금 토", 20, 620); // 요일 표시

  // 날짜 그리기
  drawCalendarDates();
}

void drawCalendarDates() {
  for (int i = 1; i <= 31; i++) {
    int x = 20 + ((i - 1) % 7) * 40; // x 좌표 계산
    int y = 640 + ((i - 1) / 7) * 15; // y 좌표 계산
    text(i, x, y); // 날짜 출력
  }
}
