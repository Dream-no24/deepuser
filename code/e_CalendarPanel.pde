// 캘린더 변수 설정
String month = "12월"; // 현재 월 이름
String[] daysOfWeek = {"일", "월", "화", "수", "목", "금", "토"}; // 요일 배열
String[][] scheduleData; // 일정 데이터
int[] categoryColors = {
  color(201, 104, 104),  // 납품: C96868 (RGB 변환)
  color(255, 255, 255),  // 미팅: White (RGB 변환)
  color(65, 242, 255),   // 점검: 41F2FF (RGB 변환)
  color(250, 223, 161)   // 일상: FADFA1 (RGB 변환)
};
String[] categories = {"납품", "미팅", "점검", "일상"}; // 카테고리 목록

// 축소 여부 및 크기
boolean isCalendarMinimized = false; // 캘린더 축소 여부
float originalWidth = 315; // 원래 너비
float originalHeight = 290; // 원래 높이
float minimizedWidth = 200; // 축소된 너비
float minimizedHeight;      // 비율에 맞는 축소된 높이
int selectedDay = -1; // 선택된 날짜 (-1은 선택된 날짜가 없음을 의미)


void drawCalendarPanel(float baseYOffset, boolean isReduced) {
  pushMatrix();

  float panelY = baseYOffset;
  float scaleFactor = isCalendarMinimized ? minimizedWidth / originalWidth : 1.0; // 축소 비율

  // 현재 높이 설정
  float currentHeight = isCalendarMinimized ? originalHeight * scaleFactor + 15 : originalHeight;

  // 배경 박스 (너비는 유지, 높이만 조정)
  fill(0, 0, 0, 160);
  rect(22.5, panelY, originalWidth, currentHeight, 20);

  // 달 이름 출력 (비율에 맞게 조정)
  textFont(boldFont);
  fill(255);
  textSize(18); // 텍스트 크기 축소
  textAlign(LEFT, CENTER);
  float monthX = width / 2 - 90; 
  if (isCalendarMinimized) {
    // 축소 상태일 때는 선택된 날짜도 함께 출력
    text(month + " " + selectedDay + "일", monthX - 35, panelY + 30);
  } else {
    // 일반 상태일 때는 달 이름만 출력
    text(month, monthX - 35, panelY + 30);
  }
  
  // 요일 및 날짜 출력  
  textFont(regularFont);
  drawDaysOfWeek(panelY + 60 * scaleFactor, scaleFactor);
  drawCalendarDates(panelY, scheduleData, scaleFactor);
  
  // 선택된 날짜 일정 표시
  drawSelectedDaySchedule(panelY);
  
  popMatrix();
}


void drawDaysOfWeek(float yOffset, float scaleFactor) {
  textSize(9 * scaleFactor); // 텍스트 크기 비율 조정
  textAlign(CENTER, CENTER);
  
  float spacingAdjustment = isCalendarMinimized ? 8 * scaleFactor : 0; // 가로 간격 조정
  
  if (isCalendarMinimized) yOffset += 15; // 축소 상태면 아래로 15만큼 내림

  for (int i = 0; i < daysOfWeek.length; i++) {
    float x = 55 + i * (42 * scaleFactor - spacingAdjustment); // X 좌표 간격 조정
    if (i == 0 || i == 6) fill(160); // 주말 색상
    else fill(255);
    text(daysOfWeek[i], x, yOffset);
  }
}




void drawCalendarDates(float panelY, String[][] scheduleData, float scaleFactor) {
  textSize(12 * scaleFactor); // 날짜 텍스트 크기 축소
  textAlign(CENTER, CENTER);

  float spacingAdjustment = isCalendarMinimized ? 8 * scaleFactor : 0; // 가로 간격 조정

  for (int i = 1; i <= 31; i++) {
    float x = 55 + ((i + 6) % 7) * (42 * scaleFactor - spacingAdjustment); // X 좌표 간격 조정
    float y = panelY + 50 * scaleFactor + ((i + 6) / 7) * 38 * scaleFactor; // Y 좌표 비율 조정

    if (isCalendarMinimized) y += 15; // 축소 상태면 아래로 15만큼 내림

    if ((i + 6) % 7 == 0) fill(200); // 일요일 색상
    else if ((i + 6) % 7 == 6) fill(180); // 토요일 색상
    else fill(255);

    text(i, x, y); // 날짜 출력
    drawCategoryDots(scheduleData[i - 1], x, y + 10 * scaleFactor, scaleFactor); // 점 출력
  }
}




// 일정 점 출력 함수
void drawCategoryDots(String[] events, float x, float y, float scaleFactor) {
  float dotX = x - 10 * scaleFactor; // X 위치 비율 조정
  int maxDots = min(events.length, 5);

  for (int i = 0; i < maxDots; i++) {
    int categoryIndex = getCategoryIndex(events[i]);
    if (categoryIndex != -1) {
      fill(categoryColors[categoryIndex]);
      ellipse(dotX + i * 5 * scaleFactor, y + 9 * scaleFactor, 4.5 * scaleFactor, 4.5 * scaleFactor); // 점 크기 및 위치 비율 조정
    }
  }
}


// 카테고리 색상 반환
int getCategoryIndex(String event) {
  String[] eventParts = event.split(" ", 3); // 시간, 카테고리, 내용 분리
  String category = eventParts[1]; // 두 번째 부분이 카테고리
  
  for (int i = 0; i < categories.length; i++) {
    if (category.equals(categories[i])) return i; // 정확한 카테고리 일치 여부 확인
  }
  return -1; // 카테고리를 찾지 못했을 경우
}


// 일정 데이터 초기화
String[][] initializeScheduleData() {
  return new String[][] {
    {"07:00 점검 - 천안시 폐터널 설비 점검", "09:30 미팅 - GS 신규 계약 논의", "11:00 납품 - emart 강남점 토마토(개포)", "13:30 납품 - 롯데마트 성수점 배추(남현)"}, // 1일
    {"08:00 납품 - emart 개포점 로즈마리(남현)", "10:00 미팅 - 스마트팜 협력사 미팅", "14:00 점검 - 개포CT 습도계 교체", "19:00 일상 - 가족 모임"}, // 2일
    {"09:00 납품 - 롯데마트 과천점 토마토(과천)", "11:30 미팅 - 공급처 방문", "15:00 점검 - 과천CT 양액 비율 조정"}, // 3일
    {"08:30 점검 - 남현CT 환기 시스템 점검", "11:00 납품 - emart 강남점 배추(개포)", "13:00 미팅 - 작물 관리 회의", "18:00 일상 - @나영 데이트"}, // 4일
    {"07:30 납품 - 롯데마트 강남점 로즈마리(남현)", "09:00 점검 - 천안시 폐터널 온습도계 점검"}, // 5일
    {}, // 일정 없는 날 (6일)
    {"19:00 일상 - @민성 저녁 식사", "07:00 점검 - 개포CT 전기 설비 확인", "11:00 납품 - emart 강남점 토마토(천안)", "14:00 미팅 - 납품 일정 조정"}, // 7일
    {"08:00 점검 - 과천CT 수분 상태 점검", "10:30 납품 - 롯데마트 성수점 배추(남현)"}, // 8일
    {"07:00 납품 - emart 개포점 로즈마리(개포)", "11:00 미팅 - 농장 운영 보고", "15:00 일상 - 운동", "16:30 점검 - 남현CT 보일러 점검"}, // 9일
    {"07:30 점검 - 천안시 폐터널 유지 보수", "09:00 납품 - 롯데마트 강남점 토마토(천안)", "13:00 미팅 - 스마트팜 프로젝트 기획", "17:00 일상 - 병원 정기검진"}, // 10일
    {"08:00 점검 - 개포CT 양액 점검", "11:30 납품 - 롯데마트 과천점 배추(남현)"}, // 11일
    {}, // 일정 없는 날 (12일)
    {"10:00 납품 - emart 강남점 배추(개포)", "13:30 미팅 - 작물 성장 데이터 공유", "15:00 점검 - 과천CT 설비 유지 관리"}, // 13일
    {"07:00 점검 - 남현CT 전기 점검", "09:30 납품 - 롯데마트 성수점 로즈마리(남현)", "19:00 일상 - @가족 영화 보기"}, // 14일
    {"08:00 납품 - emart 개포점 토마토(천안)", "11:30 미팅 - 연말 공급 계획 미팅", "15:00 점검 - 천안시 폐터널 수분 점검"}, // 15일
    {"09:00 점검 - 개포CT 영양 상태 검사", "14:00 미팅 - emart 동서울점 미팅"}, // 16일
    {"10:00 납품 - 롯데마트 강남점 배추(남현)", "15:00 일상 - 독서", "16:00 일상 - @가족 영화 보기", "17:30 점검 - 운영 보고서 검토", "18:30 점검 - 과천CT 유지 관리"}, // 17일
    {"09:00 납품 - 롯데마트 과천점 로즈마리(과천)", "11:30 미팅 - 납품 보고서 검토"}, // 18일
    {"07:00 점검 - 남현CT 보일러 점검", "13:30 미팅 - 후년 연 초 공급 계획 미팅", "15:30 납품 - emart 천안점 토마토(천안)"}, // 19일
    {"08:30 점검 - 천안시 폐터널 장비 점검", "11:00 납품 - 롯데마트 성수점 배추(남현)", "13:00 미팅 - 고객사 방문"}, // 20일
    {"07:00 납품 - 롯데마트 강남점 토마토(천안)", "08:30 점검 - 개포CT 환기 시스템 점검", "19:00 일상 - 휴식"}, // 21일
    {"08:00 점검 - 과천CT 센서 교체", "10:30 납품 - emart 개포점 로즈마리(남현)", "13:30 미팅 - 신규 장비 계약 논의"}, // 22일
    {"09:00 납품 - 롯데마트 과천점 토마토(과천)", "18:00 일상 - 병원 방문"}, // 23일
    {"10:30 미팅 - 농장 운영 리뷰", "14:00 점검 - 남현CT 유지 관리"}, // 24일
    {"07:00 납품 - emart 강남점 로즈마리(남현)", "09:00 점검 - 천안시 폐터널 유지 보수"}, // 25일
    {"07:30 점검 - 개포CT 수확 시기 확인", "11:00 납품 - 롯데마트 성수점 배추(남현)"}, // 26일
    {"09:00 납품 - 롯데마트 강남점 로즈마리(남현)", "18:30 일상 - @민준@승헌 저녁 식사", "19:00 미팅 - 공급 계획 논의"}, // 27일
    {"08:30 점검 - 남현CT 습도 체크", "16:00 일상 - @나영 쇼핑"}, // 28일
    {"07:00 납품 - emart 개포점 토마토(천안)", "09:30 점검 - 천안시 폐터널 유지 보수", "11:30 미팅 - 협력사와 회의"}, // 29일
    {}, // 일정 없는 날 (30일)
    {"08:00 점검 - 개포CT 양액 상태 점검", "11:30 납품 - 롯데마트 성수점 배추(남현)"} // 31일
  };
}


  float getTablePanelYOffset(float calendarBaseYOffset) {
  float scaleFactor = isCalendarMinimized ? minimizedWidth / originalWidth : 1.0; // 축소 비율
  float calendarHeight = isCalendarMinimized ? minimizedHeight : originalHeight; // 현재 캘린더 높이

  return calendarBaseYOffset + calendarHeight + 20 * scaleFactor; // 캘린더와의 간격 추가
}

void drawSelectedDaySchedule(float baseYOffset) {
  if (selectedDay == -1 || !isCalendarMinimized) return; // 선택된 날짜가 없거나 축소 상태가 아니면 종료

  float startX = 210; // 일정 표시 시작 X 좌표 (오른쪽 여백 조정)
  float startY = baseYOffset + 50; // Y 좌표 시작 위치

  fill(255); // 텍스트 색상
  textSize(10); // 텍스트 크기
  textAlign(LEFT, TOP);

  // 선택된 날짜의 일정 표시
  String[] events = scheduleData[selectedDay - 1]; // 선택된 날짜의 일정
if (events.length == 0) {
  text("일정 없음", startX, startY); // 일정이 없을 경우
} else {
  for (int i = 0; i < events.length; i++) {
    String[] eventParts = events[i].split(" ", 3); // 시간과 내용 분리 (공백 기준)
    String time = eventParts[0]; // 시간
    String category = eventParts[1]; // 카테고리
    String content = eventParts[2]; // 내용
    // 특정 카테고리별 점 색상 설정
    if (category.equals("납품")) {
      fill(201, 104, 104); // 빨간색
      ellipse(startX - 10, startY + i * 35 - 6, 6, 6); // 점 찍기
    } else if (category.equals("미팅")) {
      fill(255, 255, 255); // 파란색
      ellipse(startX - 10, startY + i * 35 - 6, 6, 6);
    } else if (category.equals("점검")) {
      fill(65, 242, 255); // 초록색
      ellipse(startX - 10, startY + i * 35 - 6, 6, 6);
    } else {
      fill(250, 223, 161); // 회색 (기타)
      ellipse(startX - 10, startY + i * 35 - 6, 6, 6);
    }

    // 시간과 내용을 함께 출력
    textSize(9);
    fill(255); // 글자 색은 검정
    text(time + content, startX, startY + i * 35); // 시간 + 내용 출력

    // 종류 출력 (13pt, 같은 줄)
    textSize(13);
    fill(255);
    text(category, startX - 3, startY + i * 35 - 14); // "납품", "미팅", "점검", "일상" 출력
  }
}

}



void calendarMousePressed(float baseYOffset) {
  int boxWidth = 30; // 날짜 박스의 너비
  int boxHeight = 20; // 날짜 박스의 높이

  float scaleFactor = isCalendarMinimized ? minimizedWidth / originalWidth : 1.0; // 축소 비율
  float spacingAdjustment = isCalendarMinimized ? 8 * scaleFactor : 0; // 가로 간격 조정

  for (int i = 1; i <= 31; i++) {
    // X와 Y 좌표 재계산
    float x = 55 + ((i + 6) % 7) * (42 * scaleFactor - spacingAdjustment) - boxWidth / 2;
    float y = (baseYOffset + 50 * scaleFactor + ((i + 6) / 7) * 38 * scaleFactor) - boxHeight / 2 + pos;

    // 클릭 감지
    if (mouseX > x && mouseX < x + boxWidth && mouseY > y && mouseY < y + boxHeight + 18) {
      if (isCalendarMinimized && selectedDay == i) {
        // 같은 날짜를 다시 클릭하면 축소 해제
        isCalendarMinimized = false;
        selectedDay = -1;
      } else {
        // 축소 상태로 전환하고 날짜 선택
        isCalendarMinimized = true;
        minimizedHeight = originalHeight * (minimizedWidth / originalWidth);
        selectedDay = i; // 클릭한 날짜 저장
      }
      break;
    }
  }
}
