void drawInfoPanel() {
  fill(255, 255, 255, 200);
  noStroke();
  rect(10, 10, 340, 180, 20);  

  fill(255);
  ellipse(72, 72, 100, 100);


  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Today", 70, 52);
  textSize(60);
  text("4", 70, 88);

  
  textSize(14);
  text("이번 달 총", 210, 35);
  text("1년 간 총", 210, 55);
  textSize(18);
  text("79", 285, 35);
  text("683", 275, 55);
  textSize(15);
  text("개비", 310, 35);
  text("개비", 310, 55);

  fill(100);
  textSize(12);
  text("이렇게 살다간...", 290, 90);
  
  fill(0);
  textSize(14);
  text("1년간 폐에 쌓인 유독물질 12.5g", 240, 110);
  
  fill(240);
  rect(30, 160, 300, 10, 5);
  fill(100);
  rect(30, 160, 220, 10, 5);
  
  fill(0);
  textSize(12);
  text("현재 목표: 7개 / day", 80, 145);
  text("다음 목표: 6개 / day", 280, 145);
}
