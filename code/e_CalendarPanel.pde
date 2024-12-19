import java.util.Arrays;

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

  // 현재 높이 설정 (선택된 날짜의 일정 개수를 기반으로 높이 조정)
  float currentHeight = originalHeight;
  if (selectedDay != -1 && scheduleData[selectedDay - 1] != null) {
    int extraSchedules = max(scheduleData[selectedDay - 1].length - 4, 0); // 초과 일정 개수
    currentHeight += extraSchedules * 60; // 초과 일정당 높이 증가
  }
  if (isCalendarMinimized) {
    currentHeight = currentHeight * scaleFactor + 15;
  }

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
    text(month + " " + selectedDay + "일", monthX - 35, panelY + 28);
  } else {
    // 일반 상태일 때는 달 이름만 출력
    text(month, monthX + 65, panelY + 28);
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
    if (isCalendarMinimized) x -= 15; // 축소 상태면 아래로 15만큼 내림
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
    if (isCalendarMinimized) x -= 15; // 축소 상태면 아래로 15만큼 내림


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
  
  // 이벤트를 시간순으로 정렬
  Arrays.sort(events, (a, b) -> {
    String timeA = a.split(" ", 3)[0]; // 시간 추출
    String timeB = b.split(" ", 3)[0];
    return timeA.compareTo(timeB); // 시간 비교
  });
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
    {"07:00 점검 - 천안시 폐터널", "09:30 미팅 - GS 신규 계약", "11:00 납품 - emart 강남점", "13:30 납품 - 롯데마트 성수점"}, // 1일
    {"08:00 납품 - emart 개포점", "10:00 미팅 - 스마트팜 협력", "14:00 점검 - 개포CT 습도계", "19:00 일상 - 가족 모임"}, // 2일
    {"09:00 납품 - 롯데마트 과천", "11:30 미팅 - GS 담장자 방문", "15:00 점검 - 과천CT 양액 조"}, // 3일
    {"08:30 점검 - 남현CT 환기", "11:00 납품 - emart 강남점", "13:00 미팅 - 작물 관리", "18:00 일상 - @나영 데이트"}, // 4일
    {"07:30 납품 - 롯데마트 강남", "09:00 점검 - 천안시 폐터널 점검"}, // 5일
    {}, // 일정 없는 날 (6일)
    {"19:00 일상 - @민성 중앙", "07:00 점검 - 개포CT 파이프 수리", "11:00 납품 - emart 강남점", "14:00 미팅 - 12월 납품 일정"}, // 7일
    {"08:00 점검 - 과천CT 수분", "10:30 납품 - 롯데마트 성수"}, // 8일
    {"07:00 납품 - emart 개포점", "11:00 미팅 - 농장 운영", "15:00 일상 - 운동", "17:30 점검 - 남현CT 보일러 점검"}, // 9일
    {"07:30 점검 - 천안시 폐터널", "09:00 납품 - 롯데마트 강남", "12:00 미팅 - 메트로팜 기획", "15:00 일상 - 병원 검진"}, // 10일
    {"08:00 점검 - 남현CT 양액 조정", "11:30 납품 - 롯데마트 과천"}, // 11일
    {}, // 일정 없는 날 (12일)
    {"10:00 납품 - emart 강남점", "13:30 미팅 - 작물 데이터 검토", "15:00 점검 - 과천CT 유지보수"}, // 13일
    {"07:00 점검 - 남현CT 전력 점검", "09:30 납품 - 롯데마트 성수", "19:00 일상 - @가족 영화"}, // 14일
    {"08:00 납품 - emart 개포점", "11:30 미팅 - 후년 초 계획", "15:00 점검 - 천안시 폐터널 점검"}, // 15일
    {"09:00 점검 - 개포CT 온습도계 교체", "14:00 납품 - emart 동서울"}, // 16일
    {"10:00 납품 - 롯데마트 강남", "17:00 일상 - 독서", "19:00 일상 - @가족 영화", "13:30 점검 - 운영 보고서 추합", "14:30 점검 - 과천CT 유지보수"}, // 17일
    {"07:00 점검 - 남현CT 보일러","15:00 납품 - 롯데마트 과천","10:00 납품 - 롯데마트 과천", "16:30 미팅 - 납품 보고서 검토"}, // 18일
    {"19:00 일상 - @나영 LP바", "11:30 미팅 - 운영 보고서 검토", "08:30 점검 - 개포CT 환풍기 교체", "15:30 납품 - emart 천안점"}, // 19일
    {"08:30 점검 - 천안시 폐터널", "11:00 납품 - 롯데마트 성수", "13:00 미팅 - 키친푸드랩 방문"}, // 20일
    {"07:00 납품 - 롯데마트 강남", "13:30 미팅 - 후년 초 공급 계획", "19:00 일상 - @나영 쇼핑"}, // 21일
    {"08:00 점검 - 과천CT 센서 교체", "10:30 납품 - emart 개포점", "13:30 미팅 - GS 신규 계약건 미팅"}, // 22일
    {"09:00 납품 - 롯데마트 과천", "14:00 일상 - 병원 방문"}, // 23일
    {"10:30 미팅 - 농장 운영 회고", "14:00 점검 - 남현CT 유지보수"}, // 24일
    {"07:00 납품 - emart 강남점", "09:00 점검 - 천안시 폐터널 설비점검"}, // 25일
    {"11:00 납품 - 롯데마트 성수"}, // 26일
    {"09:00 납품 - 롯데마트 강남", "18:30 일상 - @민준@승헌 불당", "13:00 미팅 - 후년 초 공급 계획"}, // 27일
    {"08:30 점검 - 남현CT 습도", "16:00 일상 - @나영 쇼핑"}, // 28일
    {"07:00 납품 - emart 개포점", "09:30 점검 - 천안시 폐터널", "11:30 미팅 - 협력사 회의"}, // 29일
    {}, // 일정 없는 날 (30일)
    {"08:00 점검 - 개포CT 양액 조정", "11:30 납품 - 롯데마트 성수"} // 31일
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
  float startY = baseYOffset + 48; // Y 좌표 시작 위치

  fill(255); // 텍스트 색상
  textSize(10); // 텍스트 크기
  textAlign(LEFT, TOP);

  // 선택된 날짜의 일정 표시
  String[] events = scheduleData[selectedDay - 1]; // 선택된 날짜의 일정
if (events.length == 0) {
} else {
  for (int i = 0; i < events.length; i++) {
    String[] eventParts = events[i].split(" ", 3); // 시간과 내용 분리 (공백 기준)
    String time = eventParts[0]; // 시간
    String category = eventParts[1]; // 카테고리
    String content = eventParts[2].replaceFirst("^- ", ""); // 내용에서 '- ' 제거 // 내용
    // 특정 카테고리별 점 색상 설정
    if (category.equals("납품")) {
      fill(201, 104, 104); // 빨간색
      ellipse(startX - 12, startY + i * 40 - 7, 4.5, 4.5); // 점 찍기
    } else if (category.equals("미팅")) {
      fill(255, 255, 255); // 파란색
      ellipse(startX - 12, startY + i * 40 - 7, 4.5, 4.5);
    } else if (category.equals("점검")) {
      fill(65, 242, 255); // 초록색
      ellipse(startX - 12, startY + i * 40 - 7, 4.5, 4.5);
    } else {
      fill(250, 223, 161); // 회색 (기타)
      ellipse(startX - 12, startY + i * 40 - 7, 4.5, 4.5);
    }

    // 시간과 내용을 함께 출력
    textSize(9);
    fill(255); // 글자 색은 검정
    text(time, startX, startY + i * 40 + 5); // 시간 출력
    text(content, startX + 27, startY + i * 40 + 5); //내용 출력

    // 종류 출력 (13pt, 같은 줄)
    textSize(13);
    fill(255);
    text(category, startX - 3, startY + i * 40 - 14); // "납품", "미팅", "점검", "일상" 출력
  }
}
}

// 캘린더 패널 높이를 계산하는 메서드
float getCalendarPanelHeight() {
  float scaleFactor = isCalendarMinimized ? minimizedWidth / originalWidth : 1.0;
  float baseHeight = originalHeight;

  // 초과 일정 개수에 따른 높이 조정
  if (selectedDay != -1 && scheduleData[selectedDay - 1] != null) {
    int extraSchedules = max(scheduleData[selectedDay - 1].length - 4, 0); // 초과 일정 개수
    baseHeight += extraSchedules * 40; // 초과 일정당 40씩 증가
  }

  // 축소 여부에 따른 비율 적용
  if (isCalendarMinimized) {
    return baseHeight * scaleFactor + 15;
  } else {
    return baseHeight;
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
    if (isCalendarMinimized) x -= 15; // 축소 상태면 아래로 15만큼 내림

    // 클릭 감지
    if (mouseX > x && mouseX < x + boxWidth && mouseY > y  - 40 * scaleFactor + 40 && mouseY < y + boxHeight + 18 * scaleFactor - 40 * scaleFactor + 40 ) {
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
