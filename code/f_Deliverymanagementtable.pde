String[] headers = {"날짜", "납품처", "품목(지점)", "납품", "재고"};
String[][] data = {
  {"11/02", "emart 강남점", "배추(남현)", "120", "80"},
  {"11/02", "emart 강남점", "토마토(천안)", "120", "120"},
  {"11/24", "롯데마트 성수점", "토마토(천안)", "80", "110"},
  {"11/27", "롯데마트 강남점", "로즈마리(남현)", "120", "60"},
  {"11/28", "emart 개포점", "로즈마리(남현)", "200", "140"},
  {"11/30", "롯데마트 과천점", "로즈마리(남현)", "190", "80"}
};

float tableHeight = 35; // 테이블 높이
float rowHeight = 30; // 각 행 높이
float headerHeight = 35; // 헤더 높이

void drawTablePanel(float baseYOffset) {
  float startX = 22.5; // 테이블 시작 X 좌표
  float tableWidth = 315; // 테이블 가로 길이
  float tableStartY = baseYOffset; // 테이블의 시작 Y 좌표

  // 비율에 따른 열 너비 계산
  float[] columnWidths = {
    tableWidth * 2 / 16, // 날짜 (2 비율)
    tableWidth * 4 / 16, // 납품처 (4 비율)
    tableWidth * 5 / 16, // 품목 (4 비율)
    tableWidth * 2 / 16, // 납품 (3 비율)
    tableWidth * 3 / 16  // 재고 (3 비율)
  };

  // 테이블 전체 배경
  fill(0, 0, 0, 190); // 반투명 검은 배경
  rect(startX, tableStartY, tableWidth, tableHeight, 20, 20, 0, 0); 

  // 헤더
  fill(255); // 흰색 텍스트
  textSize(12); // 헤더 글씨 크기
  textAlign(CENTER, CENTER);
  float colStartX = startX; // 열의 시작 X 좌표
  for (int i = 0; i < headers.length; i++) {
    text(headers[i], colStartX + columnWidths[i] / 2, tableStartY + headerHeight / 2);
    colStartX += columnWidths[i];
  }

  // 데이터 출력 (다섯 개의 항목만 표시)
  for (int i = 0; i < min(data.length, 5); i++) {
    float y = tableStartY + headerHeight + i * rowHeight;

    // 마지막 줄은 아래쪽 모서리를 둥글게 처리
    if (i == 4) {
      fill(0, 0, 0, 160); // 반투명 검은 배경
      rect(startX, y, tableWidth, rowHeight + 5, 0, 0, 20, 20); // 하단만 둥글게
    } else {
      fill(0, 0, 0, 160); // 반투명 검은 배경
      rect(startX, y, tableWidth, rowHeight, 0); // 각진 모서리
    }

    // 데이터 텍스트 출력
    fill(255); // 데이터 텍스트 흰색
    textSize(10); // 데이터 글씨 크기 축소
    textAlign(CENTER, CENTER);
    colStartX = startX; // 열의 시작 X 좌표
    for (int j = 0; j < data[i].length; j++) {
      text(data[i][j], colStartX + columnWidths[j] / 2, y + rowHeight / 2);
      colStartX += columnWidths[j];
    }
  }
}
