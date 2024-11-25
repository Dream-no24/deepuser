void drawInfoPanel() {
  fill(255, 255, 255, 200);
  noStroke();
  rect(10, 10, 340, 180, 20);  

  fill(0);
  textSize(24);
  textAlign(LEFT, CENTER);
  text("Today", 20, 40);
  textSize(32);
  text("4", 100, 40);
  
  textSize(14);
  text("이번 달 총", 210, 40);
  text("1년 간 총", 210, 60);
  textSize(18);
  text("79 개비", 280, 37);
  text("683 개비", 270, 57);

  fill(150);
  textSize(12);
  text("이렇게 살다간...", 250, 90);
  
  fill(0);
  textSize(14);
  text("1년간 폐에 쌓인 유독물질 12.5g", 140, 110);
  
  fill(230);
  rect(20, 160, 200, 10, 5);
  fill(100, 200, 255);
  rect(20, 160, 130, 10, 5);
  textSize(12);
  text("현재 목표: 7개 / day", 250, 175);
  text("다음 목표: 6개 / day", 250, 195);
}
