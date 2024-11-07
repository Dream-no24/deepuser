PFont font;
PImage img;

void setup() {
  size(400, 1000);  // 캔버스 크기
  background(50, 50, 50);  // 어두운 배경색

  // 바탕이미지 추가
  img = loadImage("deepuser.png");  
  smooth();

  // 폰트 설정 (data 폴더에 AppleSDGothicNeo.ttc가 있다고 가정)
  font = createFont("AppleSDGothicNeo.ttc", 14);
  textFont(font);
}

void draw() {
  // 이미지 배경을 그리기 위한 코드 (draw의 첫 줄에 배치)
  image(img, 0, 0, width, height);

  // 상단 패널: 담배 소비 추적 정보
  fill(255, 255, 255, 220);  // 약간 투명한 흰색
  noStroke();
  rect(10, 10, 380, 180, 20);  // 둥근 모서리

  // 날짜 및 개비 수 정보
  fill(0);
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Today", 20, 40);
  textSize(32);
  text("4", 100, 40);
  
  textSize(14);
  text("이번 달 총", 20, 80);
  text("1년 간 총", 20, 110);
  textSize(18);
  fill(255, 100, 100);  // 강조를 위한 빨간색
  text("79 개비", 120, 80);
  text("683 개비", 120, 110);

  // 경고 문구
  fill(150);
  textSize(12);
  text("이렇게 살다간...", 20, 140);
  
  // 유독물질 축적량
  fill(0);
  textSize(14);
  text("1년간 폐에 쌓인 유독물질 12.5g", 20, 160);
  
  // 목표 진행 바
  fill(230);
  rect(20, 180, 200, 10, 10);  // 기본 진행 바 - 둥근 테두리 적용
  fill(100, 200, 255);
  rect(20, 180, 130, 10, 10);  // 현재 진행 수준 - 둥근 테두리 적용
  
  textSize(12);
  fill(0);
  text("현재 목표: 7개 / day", 250, 175);
  text("다음 목표: 6개 / day", 250, 195);

  // Issues와 일정 섹션을 2열로 배치
  fill(255, 255, 255, 220);  // 패널 배경
  rect(10, 210, 185, 185, 20);  // Issues 패널 (높이 185)
  rect(205, 210, 185, 185, 20);  // 일정 패널 (높이 185)

  // Issues 섹션
  fill(0);
  textSize(16);
  text("Issues", 20, 240);
  textSize(14);
  text("개포동 컨테이너  1", 20, 265);
  text("천안시 페터널  2", 20, 285);
  text("남현동 컨테이너  3", 20, 305);

  // 일정 섹션
  fill(0);
  textSize(16);
  text("10월 17일", 215, 240);
  textSize(12);
  text("미팅 11:00  GS 담당자 미팅", 215, 265);
  text("점검 13:00  남현동 컨테이너 설비 점검", 215, 285);
  text("납품 15:00  페터널 - emart 천안점 납품", 215, 305);

  // 환경 모니터링 정보
  fill(255, 255, 255, 220);
  rect(10, 400, 380, 70, 20);  // 패널 크기와 둥근 모서리 적용
  textSize(16);
  fill(0);
  text("천안시 페터널", 20, 430);
  textSize(12);
  text("습도 52%, 온도 27도, 조도 55lx, 물 2.5L", 20, 450);

  // 비용 그래프 섹션
  fill(255, 255, 255, 220);
  rect(10, 480, 380, 80, 20);  // 패널 크기와 둥근 모서리 적용
  fill(0);
  textSize(16);
  text("Total Cost of Oct", 20, 510);
  textSize(14);
  text("매출 10000원 당 4294원", 20, 530);
  
  // 캘린더 섹션
  fill(255, 255, 255, 220);
  rect(10, 570, 380, 150, 20);  // 패널 크기와 둥근 모서리 적용
  fill(0);
  textSize(16);
  text("10월", 20, 600);
  textSize(12);
  text("일 월 화 수 목 금 토", 20, 620);
  
  // 임시 일정 점 표시
  for (int i = 1; i <= 31; i++) {
    int x = 20 + ((i - 1) % 7) * 50;
    int y = 640 + ((i - 1) / 7) * 15;
    text(i, x, y);
  }
}
