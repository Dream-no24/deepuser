import java.time.*;
import java.time.format.*;
import java.util.ArrayList;

// 날짜 처리용 변수
LocalDate today = LocalDate.now();
String[][] filteredData;

// 데이터 초기화
String[] headers = {"날짜", "납품처", "품목(지점)", "납품", "재고"};
String[][] data = {
  {"12/16", "롯데마트 성수점", "토마토(천안)", "80", "110"},
  {"12/19", "롯데마트 성수점", "토마토(천안)", "80", "110"},
  {"12/29", "롯데마트 강남점", "로즈마리(남현)", "120", "154"},
  {" 1/13", "emart 강남점", "배추(남현)", "120", "230"},
  {" 1/15", "emart 천안점", "토마토(천안)", "130", "150"},
  {" 1/19", "emart 강남점", "치커리(개포)", "110", "120"},
  {" 1/21", "emart 강남점", "상추(개포)", "110", "120"},
  {" 1/20", "emart 강남점", "치커리(개포)", "110", "120"}
};

float tableHeight = 35; // 테이블 높이
float rowHeight = 30; // 각 행 높이
float headerHeight = 35; // 헤더 높이

// 테이블 그리기
void drawTablePanel(float baseYOffset) {
  float startX = 22.5;
  float tableWidth = 315;
  float tableStartY = baseYOffset;

  // 열 너비 비율 계산
  float[] columnWidths = {
    tableWidth * 2 / 16, // 날짜
    tableWidth * 4 / 16, // 납품처
    tableWidth * 5 / 16, // 품목(지점)
    tableWidth * 2 / 16, // 납품
    tableWidth * 3 / 16  // 재고
  };

  // 테이블 헤더 그리기
  textFont(boldFont);
  fill(0, 0, 0, 190);
  rect(startX, tableStartY, tableWidth, tableHeight, 20, 20, 0, 0);
  fill(255);
  textSize(12);
  textAlign(CENTER, CENTER);
  float colStartX = startX;
  for (int i = 0; i < headers.length; i++) {
    text(headers[i], colStartX + columnWidths[i] / 2, tableStartY + headerHeight / 2);
    colStartX += columnWidths[i];
  }

  // 데이터 출력
  textFont(regularFont);
  for (int i = 0; i < filteredData.length; i++) {
    float y = tableStartY + headerHeight + i * rowHeight;

    // 마지막 줄만 아래쪽 모서리를 둥글게
    if (i == filteredData.length - 1) {
      fill(0, 0, 0, 160);
      rect(startX, y, tableWidth, rowHeight, 0, 0, 20, 20);
    } else {
      fill(0, 0, 0, 160);
      rect(startX, y, tableWidth, rowHeight);
    }

    // 데이터 출력
    fill(255);
    textSize(10);
    textAlign(CENTER, CENTER);
    colStartX = startX;
    for (int j = 0; j < filteredData[i].length; j++) {
      text(filteredData[i][j], colStartX + columnWidths[j] / 2, y + rowHeight / 2);
      colStartX += columnWidths[j];
    }
  }
}

// 날짜 필터링 함수
void filterDataWithinOneMonth() {
  ArrayList<String[]> tempList = new ArrayList<>();
  LocalDate thisYearToday = LocalDate.now();

  for (int i = 0; i < data.length; i++) {
    String dateStr = data[i][0].trim();
    dateStr = dateStr.replace(" ", ""); // 공백 제거

    // 연도 추가: 1월은 다음 연도, 12월은 현재 연도
    int month = Integer.parseInt(dateStr.split("/")[0]);
    int day = Integer.parseInt(dateStr.split("/")[1]);
    int year = (month == 1) ? thisYearToday.getYear() + 1 : thisYearToday.getYear();

    try {
      LocalDate dataDate = LocalDate.of(year, month, day);

      // 한 달 이내 날짜만 필터링
      if (!dataDate.isBefore(thisYearToday) && dataDate.isBefore(thisYearToday.plusMonths(1).plusDays(1))) {
        tempList.add(data[i]);
      }
    } catch (Exception e) {
      println("Invalid date format: " + dateStr); // 잘못된 날짜 출력
    }
  }

  // 필터링된 데이터를 배열로 변환
  filteredData = tempList.toArray(new String[tempList.size()][]);
}
