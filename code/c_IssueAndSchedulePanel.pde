void drawIssueAndSchedulePanels(float baseYOffset) {
  float panelWidth = 315; // 패널 너비
  float panelY = baseYOffset; // 패널의 Y 오프셋 위치

  // "Issues" 패널 (왼쪽)
  PImage issueImage = loadImage("../data/IssueAndSchedulePanels.png"); // 이미지 로드
  image(issueImage, 23.3, panelY, panelWidth, 150); // 왼쪽 패널 출력

  

  // 문제 목록
  String[] issues = {"개포동 컨테이너", "천안시 페터널", "남현동 컨테이너"};
  for (int i = 0; i < issues.length; i++) {
  fill(0); // 텍스트 색상
  textSize(12);
  textAlign(LEFT, CENTER);    text(issues[i], 40, panelY + 55 + i * 21);

    // 원과 숫자 출력
    float circleX = 140; // 원의 X 좌표
    float circleY = panelY + 55 + i * 21; // 원의 Y 좌표
    float circleSize = 16; // 원 크기

    fill(255); // 원 배경색
    ellipse(circleX, circleY, circleSize, circleSize); // 원 그리기

    fill(0); // 숫자 색상
    textSize(10); // 숫자 텍스트 크기
    textAlign(CENTER, CENTER); // 숫자를 원의 중심에 배치
    text(i + 1, circleX, circleY); // 숫자 출력
  }

  // "10월 17일" 패널 (오른쪽)
  fill(255); // 텍스트 색상
  textSize(12);
  textAlign(LEFT, CENTER);
  text("10", 223, panelY + 20); // 날짜 월 텍스트
  text("17", 249, panelY + 20); // 날짜 일 텍스트


  // 일정 항목
  String[][] schedules = {
    {"미팅", "11:00", "GS 담당자 미팅"},
    {"점검", "13:00", "남현동 컨테이너 설비 점검"},
    {"납품", "15:00", "페터널 - emart 천안점 납품"}
  };

  float scheduleStartY = panelY + 45; // 일정 시작 Y 위치
  for (int i = 0; i < schedules.length; i++) {
    // 종류 출력 (13pt)
    textFont(boldFont);
    textSize(13);
    text(schedules[i][0], 210, scheduleStartY + i * 30); // 종류  출력

    // 시간 출력 (10pt, 같은 줄)
    textFont(regularFont);
    textSize(10);
    text(schedules[i][1], 235, scheduleStartY + i * 30); // 시간 출력

    // 세부 내용 출력 (10pt, 아래 줄)
    textSize(9);
    text(schedules[i][2], 215, scheduleStartY + i * 30 + 15); // 세부 일정 출력
  }
}
