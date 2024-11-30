String[] headers = {"날짜", "납품처", "품목 (지점)", "납품", "재고"};
String[][] data = {
  {"11/02", "emart 강남점", "배추 (남현)", "120", "80"},
  {"11/02", "emart 강남점", "토마토 (천안)", "120", "120"},
  {"11/24", "롯데마트 성수점", "토마토 (천안)", "80", "110"},
  {"11/27", "롯데마트 강남점", "로즈마리 (남현)", "120", "60"},
  {"11/28", "emart 개포점", "로즈마리 (남현)", "200", "140"},
  {"11/30", "롯데마트 과천점", "로즈마리 (남현)", "190", "80"}
};

float tableStartY = 1200; // 테이블의 시작 Y 좌표
float tableHeight = 300; // 테이블 높이
float rowHeight = 35; // 각 행 높이
float headerHeight = 50; // 헤더 높이
float scrollOffset = 0; // 세로 스크롤 오프셋

void drawTablePanel() {
  float startX = 10; // 테이블 시작 X 좌표
  float tableWidth = width - 2 * startX; // 테이블 가로 길이

  // 테이블 전체 배경
  fill(0, 0, 0, 160); // 반투명 검은 배경
  rect(startX, tableStartY, tableWidth, tableHeight, 20);

  // 헤더
  fill(255); // 흰색 텍스트
  textSize(12); // 헤더 글씨 크기
  textAlign(CENTER, CENTER);
  for (int i = 0; i < headers.length; i++) {
    float colWidth = tableWidth / headers.length;
    text(headers[i], startX + i * colWidth + colWidth / 2, tableStartY + headerHeight / 2);
  }

  // 데이터 클리핑
  clip(startX, tableStartY + headerHeight, tableWidth, tableHeight - headerHeight);

  // 데이터 출력
  for (int i = 0; i < data.length; i++) {
    float y = tableStartY + headerHeight + i * rowHeight - scrollOffset;
    if (y + rowHeight > tableStartY + headerHeight && y < tableStartY + tableHeight) {
      fill(0, 0, 0, 160); // 반투명 검은 배경
      rect(startX, y, tableWidth, rowHeight);

      fill(255); // 데이터 텍스트 흰색
      textSize(10); // 데이터 글씨 크기 축소
      textAlign(CENTER, CENTER);
      for (int j = 0; j < data[i].length; j++) {
        float colWidth = tableWidth / headers.length;
        text(data[i][j], startX + j * colWidth + colWidth / 2, y + rowHeight / 2);
      }
    }
  }
  noClip(); // 클리핑 해제
}
