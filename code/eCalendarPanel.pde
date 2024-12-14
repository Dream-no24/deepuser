void drawCalendarPanel(float baseYOffset) {
  // 캘린더 패널
  float panelY = baseYOffset; // baseYOffset으로 Y 위치 설정
  fill(0, 0, 0, 160); // 패널 배경 색
  rect(22.5, panelY, 315, 290, 20); // 둥근 모서리 패널

  // '10월' 텍스트
  fill(255); // 흰색 텍스트
  textSize(18);
  textAlign(CENTER, CENTER);
  text("10월", width / 2, panelY + 30); // 중앙에 정렬

  // 요일 텍스트
  textSize(9);
  for (int i = 0; i < 7; i++) {
    if (i == 0) fill(200); // 일요일 (회색)
    else if (i == 6) fill(180); // 토요일 (연한 회색)
    else fill(255); // 평일 (흰색)
    textAlign(CENTER, CENTER); // 가운데 정렬
    text(getDayName(i), 55 + i * 42, panelY + 60); // 요일 배치
  }

  // 날짜 그리기
  drawCalendarDates(panelY);
}

void drawCalendarDates(float panelY) {
  textSize(12); // 날짜 텍스트 크기 설정
  for (int i = 1; i <= 31; i++) {
    int x = 55 + ((i + 6) % 7) * 42; // x 좌표 (요일 간격 조정, 10월 1일이 일요일 기준)
    int y = (int) (panelY + 50 + ((i + 6) / 7) * 38); // float -> int로 변환

    if ((i + 6) % 7 == 0) fill(200); // 일요일 (회색)
    else if ((i + 6) % 7 == 6) fill(180); // 토요일 (연한 회색)
    else fill(255); // 평일 (흰색)
    textAlign(CENTER, CENTER); // 가운데 정렬
    text(i, x, y); // 날짜 출력
  }
}


String getDayName(int day) {
  // 요일 이름 반환
  String[] days = {"일", "월", "화", "수", "목", "금", "토"};
  return days[day];
}
