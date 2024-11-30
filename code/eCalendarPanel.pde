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
