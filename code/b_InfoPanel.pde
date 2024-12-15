void drawInfoPanel(float infoPanelYOffset) {

  // Cigarette Manager 이미지 불러오기 및 배경에 그리기
  PImage cigaretteManagerImg = loadImage("../data/CigaretteManager.png");
  image(cigaretteManagerImg, 11.5, infoPanelYOffset, 350, 212);

  // 지정된 텍스트만 이미지 위에 그리기
  fill(0); // 검정색 텍스트

  // "4"
  textSize(60);
  textAlign(CENTER, CENTER);
  text("4", 70, infoPanelYOffset + 88);

  // "1년간 폐에 쌓인 유독물질 12.5g"
  textSize(14);
  text("1년간 폐에 쌓인 유독물질 12.5g", 240, infoPanelYOffset + 110);

  // "79"
  textSize(18);
  text("79", 285, infoPanelYOffset + 35);

  // "683"
  textSize(18);
  text("683", 275, infoPanelYOffset + 55);

  // "현재 목표: 7개 / day" 중 '7'만
  textSize(12);
  text("7", 100, infoPanelYOffset + 145);

  // "다음 목표: 6개 / day" 중 '6'만
  textSize(12);
  text("6", 300, infoPanelYOffset + 145);
}
