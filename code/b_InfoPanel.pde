// 현재 버튼 값과 클릭 감지 변수
int dailyCigarettes = 0; // 버튼의 초기 숫자
float buttonX = 86.3; // 버튼의 X 위치
float buttonY; // 버튼의 Y 위치 (동적으로 계산)
float buttonSize = 60; // 버튼 크기

// 페이드 효과 관련 변수
int currentTextIndex = 0; // 현재 문구 인덱스
long lastSwitchTime = 0; // 마지막 문구 전환 시간
long switchInterval = 8000; // 문구 전환 간격
long fadeDuration = 500; // 페이드인/페이드아웃 시간 (0.5초)
int alpha = 255; // 텍스트 투명도
float textCenterX = 233; // 텍스트 중앙 위치

// 클릭 감지 관련 변수
int clickCount = 0; // 클릭 횟수
long lastClickTime = 0; // 마지막 클릭 시간

// 계산용 상수
int baseMonthly = 134; // 이번 달 기본값
int baseAnnual = 2634; // 1년 기본값
float harmfulSubstancesPerCigarette = 0.002f; // 1개비당 유해물질 축적량 (g)
int pricePerCigarette = 4500 / 20; // 한 갑에 4500원 기준, 개비당 약 225원
float cancerRiskIncreasePerCigarette = 0.0001f; // 개비당 폐암 발병 확률 증가율
int lifeReductionPerCigarette = 11; // 1개비당 11분 단축
int targetCigarettes = 7; // 현재 목표치

// Track 이미지 변수
PImage trackImg;

void drawInfoPanel(float infoPanelYOffset) {
  // Cigarette Manager 이미지 불러오기 및 배경에 그리기
  PImage cigaretteManagerImg = loadImage("../data/CigaretteManager.png");
  PImage trackImg = loadImage("../data/Track.png");
  image(cigaretteManagerImg, 11.5, infoPanelYOffset, 350, 212);

  // 버튼 Y 위치 계산
  buttonY = infoPanelYOffset + 92;

  // 버튼으로 동작하는 숫자 출력
  fill(0); // 검정색 텍스트
  textSize(buttonSize);
  textAlign(CENTER, CENTER);
  text(dailyCigarettes, buttonX, buttonY);

  // "이번 달 총" 및 "1년간 총" 계산
  int todayCigarettes = dailyCigarettes; // 오늘 흡연량
  int totalMonthlyCigarettes = baseMonthly + todayCigarettes; // 이번 달 총 개비수
  int totalAnnualCigarettes = baseAnnual + todayCigarettes; // 연간 총 개비수

  // 계산된 값
  float annualHarmfulSubstances = totalAnnualCigarettes * harmfulSubstancesPerCigarette; // 연간 유해물질 축적량
  int annualCost = totalAnnualCigarettes * pricePerCigarette; // 연간 담배값
  float annualCancerRiskIncrease = totalAnnualCigarettes * cancerRiskIncreasePerCigarette * 100; // 연간 폐암 발병 확률 증가
  int annualLifeReduction = totalAnnualCigarettes * lifeReductionPerCigarette; // 연간 수명 단축 (분)

  // 오늘 날짜를 기반으로 이번 달의 진행률 계산
  int dayOfMonth = day(); // 오늘 날짜
  int totalDaysInMonth = monthDays(month(), year()); // 이번 달 총 일수 계산
  int progressPercentage = (int) ((float) dayOfMonth / totalDaysInMonth * 100); // 이번 달 진행률

  // Track 이미지 진행률 출력 부분
  float progressBarX = 36.5; // 프로그래스바 시작 X 좌표
  float progressBarY = infoPanelYOffset + 175; // 프로그래스바 Y 좌표
  float fixedHeight = 8; // 프로그래스바 고정 세로 높이
  float fixedWidth = 340; // 프로그래스바 고정 가로 길이
  float progressBarWidth = dailyCigarettes > targetCigarettes ? 0 : map(progressPercentage, 0, 100, 0, fixedWidth); // 목표 초과 시 0, 아니면 정상 진행

  // 진행된 부분만 출력
  image(trackImg, progressBarX, progressBarY, progressBarWidth, fixedHeight); 

  fill(255);
  textAlign(LEFT, CENTER);
  textSize(8);
  text(progressPercentage + "%", progressBarX + progressBarWidth - 18, progressBarY + fixedHeight / 2 - 0.3); // 진행률 텍스트 출력

  // 월 개비수와 연간 개비수 텍스트 출력 (항상 표시)
  fill(0);
  textAlign(CENTER, BASELINE);
  textSize(20);
  text(totalMonthlyCigarettes, 267, infoPanelYOffset + 59); // 이번 달 총 개비수
  text(totalAnnualCigarettes, 267, infoPanelYOffset + 83); // 연간 총 개비수

  // 현재 목표와 다음 목표 텍스트 (항상 표시)
  textSize(12);
  text("7", 41.9, infoPanelYOffset + 169); // 현재 목표
  text("6", 282.9, infoPanelYOffset + 169); // 다음 목표

  // 페이드 효과 및 문구 변경
  long currentTime = millis();
  long elapsedTime = currentTime - lastSwitchTime;

  if (elapsedTime > switchInterval) {
    // 문구 변경 및 초기화
    currentTextIndex = (currentTextIndex + 1) % 4; // 문구 인덱스는 4개 문구로 제한
    lastSwitchTime = currentTime;
  }

  if (elapsedTime < fadeDuration) {
    // 페이드아웃
    alpha = (int) map(elapsedTime, 0, fadeDuration, 0, 255); 
  } else if (elapsedTime > switchInterval - fadeDuration) {
    // 페이드인
    alpha = (int) map(elapsedTime, switchInterval - fadeDuration, switchInterval, 255, 0); 
  } else {
    // 완전히 보임
    alpha = 255;
  }

  // 2차원 배열로 문구 생성
  String[][] messages = {
    {"1년간 폐에 쌓인 유독물질 ", String.format("%.2f", annualHarmfulSubstances), " g"},
    {"1년간 담배값 ", String.format("%,d", annualCost), "원"},
    {"1년간 폐암 발병 확률 ", String.format("%.2f", annualCancerRiskIncrease), "% 증가"},
    {"1년간 수명 ", String.format("%d", annualLifeReduction), "분 단축"}
  };

  // 문구 출력 (숫자 강조)
  drawSplitMessageWithHighlight(messages[currentTextIndex], textCenterX, infoPanelYOffset + 127, alpha);
}

void drawSplitMessageWithHighlight(String[] splitMessage, float centerX, float centerY, int alpha) {
  // 텍스트 스타일 설정
  textAlign(CENTER, CENTER);
  fill(0, alpha);

  // 초기 텍스트 크기 설정
  float baseTextSize = 30; // 일반 텍스트 기본 크기
  float numberTextSize = baseTextSize + 4; // 숫자 텍스트 크기 (2 더 큼)
  float maxWidth = 165; // 최대 가로 길이

  // 텍스트 크기 동적 조정
  textSize(baseTextSize);
  float prefixWidth = textWidth(splitMessage[0]);
  textSize(numberTextSize);
  float numberWidth = textWidth(splitMessage[1]);
  textSize(baseTextSize);
  float suffixWidth = textWidth(splitMessage[2]);

  // 전체 폭 계산
  float totalWidth = prefixWidth + numberWidth + suffixWidth;

  // 텍스트가 maxWidth를 초과할 경우 크기 축소
  while (totalWidth > maxWidth) {
    baseTextSize -= 0.5; // 일반 텍스트 크기 줄이기
    numberTextSize = baseTextSize + 4; // 숫자 텍스트 크기 동기화
    textSize(baseTextSize);
    prefixWidth = textWidth(splitMessage[0]);
    suffixWidth = textWidth(splitMessage[2]);
    textSize(numberTextSize);
    numberWidth = textWidth(splitMessage[1]);
    totalWidth = prefixWidth + numberWidth + suffixWidth; // 총 폭 재계산
  }

  // 출력 시작 X 좌표 계산
  float startX = centerX - totalWidth / 2;

  // 텍스트 출력
  textSize(baseTextSize); // 일반 텍스트 크기
  text(splitMessage[0], startX + prefixWidth / 2, centerY + 0.5); // 앞부분 출력
  textSize(numberTextSize); // 숫자 강조 크기
  text(splitMessage[1], startX + prefixWidth + numberWidth / 2, centerY - 0.5); // 숫자 출력
  textSize(baseTextSize); // 일반 텍스트 크기
  text(splitMessage[2], startX + prefixWidth + numberWidth + suffixWidth / 2, centerY + 0.5); // 뒷부분 출력
}

// 특정 달의 일수 계산 함수
int monthDays(int month, int year) {
  if (month == 2) { // 2월은 윤년 계산
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) return 29;
    else return 28;
  }
  if (month == 4 || month == 6 || month == 9 || month == 11) return 30; // 30일인 달
  return 31; // 나머지는 31일
}

// 버튼 클릭 감지 함수
boolean isMouseOverButton() {
  float adjustedY = buttonY + pos; // 스크롤 값 반영
  return mouseX > buttonX - buttonSize / 2 && mouseX < buttonX + buttonSize / 2 &&
         mouseY > adjustedY - buttonSize / 2 && mouseY < adjustedY + buttonSize / 2;
}

// 클릭 처리 함수
void infoPanelMousePressed() {
  if (isMouseOverButton()) {
    long currentTime = millis();
    if (currentTime - lastClickTime < 400) { // 400ms 이내에 클릭하면 더블 클릭으로 간주
      clickCount++;
    } else {
      clickCount = 1; // 클릭 간격이 길면 새롭게 시작
    }
    lastClickTime = currentTime;

    // 클릭 처리
    if (clickCount == 2) { // 더블 클릭 시 증가
      delay(200); // 200ms 딜레이 추가
      dailyCigarettes++;
      println("더블 클릭: Daily Cigarettes 증가 -> " + dailyCigarettes);
    } else if (clickCount == 3) { // 세 번 클릭 시 감소
      dailyCigarettes = max(0, dailyCigarettes - 2); // 0 이하로 감소하지 않도록 제한
      println("세 번 클릭: Daily Cigarettes 감소 -> " + dailyCigarettes);
      clickCount = 0; // 세 번 클릭 후 리셋
    }
  }
}
