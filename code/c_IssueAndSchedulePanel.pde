void drawIssueAndSchedulePanels(float baseYOffset) {
  float panelWidth = 315; // 패널 너비
  float panelSpacing = 20;          // 패널 간격
  float panelY = baseYOffset;       // Cigarette Manager 패널 아래로 설정된 위치

  // "Issues" 패널 (왼쪽)
  PImage issueImage = loadImage("../data/IssueAndSchedulePanels.png"); // 이미지 로드
  image(issueImage, 23.3, panelY, panelWidth, 150); // 왼쪽 패널 출력

  fill(0); // 텍스트 색상
  textSize(16);
  textAlign(LEFT, CENTER);

  textSize(14);
  String[] issues = {"개포동 컨테이너", "천안시 페터널", "남현동 컨테이너"};
  for (int i = 0; i < issues.length; i++) {
    text(issues[i], 30, panelY + 55 + i * 23); // 각 이슈 항목 텍스트
  }

  // "10월 17일" 패널 (오른쪽)
  fill(255); // 텍스트 색상
  textSize(13);
  textAlign(LEFT, CENTER);
  text("10  17", 222, panelY + 20);

  // 일정 항목
  textSize(14);
  String[] schedules = {
    "미팅 11:00   GS 담당자 미팅",
    "점검 13:00   남현동 컨테이너 설비 점검",
    "납품 15:00   페터널 - emart 천안점 납품"
  };

  for (int i = 0; i < schedules.length; i++) {
    text(schedules[i], 215, panelY + 45 + i * 30); // 각 일정 출력
  }
}
