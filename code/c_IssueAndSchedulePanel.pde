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
    textAlign(LEFT, CENTER);
    text(issues[i], 40, panelY + 55 + i * 21);

    // 원과 숫자 출력
    float circleX = 140; // 원의 X 좌표
    float circleY = panelY + 55 + i * 21; // 원의 Y 좌표
    float circleSize = 16; // 원 크기

    fill(255); // 원 배경색
    ellipse(circleX, circleY, circleSize, circleSize); // 원 그리기

    fill(0); // 숫자 색상
    textSize(10); // 숫자 텍스트 크기
    textAlign(CENTER, CENTER);
    text(i + 1, circleX, circleY); // 숫자 출력
  }

  // "오늘 일정" 패널 (오른쪽)
  fill(255); // 텍스트 색상
  textSize(12);
  textAlign(LEFT, CENTER);

  int todayMonth = month(); // 현재 월 가져오기
  int todayDay = day();     // 현재 일 가져오기
  text(todayMonth + "     " + todayDay, 224, panelY + 20); // "월 일" 형태로 출력

  String[][] schedules = initializeScheduleData();

  // 현재 날짜를 기반으로 일정 가져오기
  String[] todaySchedules;
  if (todayDay > schedules.length) {
    todaySchedules = new String[0]; // 날짜 범위를 초과한 경우 빈 배열 반환
  } else {
    todaySchedules = schedules[todayDay - 1]; // 오늘 날짜에 맞는 일정 가져오기
  }

  float scheduleStartY = panelY + 50; // 일정 시작 위치

  if (todaySchedules.length == 0) {
    // 일정이 없을 경우 메시지 출력
    fill(255);
    textSize(10);
    text("오늘은 일정이 없습니다.", 223, scheduleStartY);
    return;
  }

  // 일정 출력
  for (int i = 0; i < todaySchedules.length; i++) {
    String[] scheduleParts = todaySchedules[i].split(" - ");
    String category = scheduleParts[0].split(" ")[1]; // 카테고리 (납품, 미팅, 점검, 일상)
    String time = scheduleParts[0].split(" ")[0]; // 시간
    String detail = scheduleParts[1]; // 세부 내용

    // 카테고리별 색상 적용
    if (category.equals("납품")) fill(categoryColors[0]); // 빨간색
    else if (category.equals("미팅")) fill(categoryColors[1]); // 흰색
    else if (category.equals("점검")) fill(categoryColors[2]); // 파란색
    else if (category.equals("일상")) fill(categoryColors[3]); // 노란색
    else fill(200); // 기타
    
    
    ellipse(206, scheduleStartY - 5 + i * 30, 6, 6); // 원 그리기
    
    fill(255); // 세부 일정 색상: 검정
    textFont(boldFont);
    textSize(12);
    text(category, 220, scheduleStartY + i * 30 - 11); // 카테고리 출력
    
    textFont(regularFont);
    textSize(10);
    text(time, 244, scheduleStartY + i * 30 - 10); // 시간 출력
    text(detail, 222, scheduleStartY + i * 30 + 2); // 세부 일정 출력
  }
}
