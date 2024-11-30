void drawIssueAndSchedulePanels() {
  float panelWidth = (340 - 20) / 2;
  float panelSpacing = 20;
  
  textAlign(LEFT, CENTER);
  fill(255, 255, 255, 230);
  rect(10, 210, panelWidth, 160, 20);
  fill(0);
  textSize(16);
  text("Issues", 20, 240);
  textSize(14);
  String[] issues = {"개포동 컨테이너", "천안시 페터널", "남현동 컨테이너"};
  for (int i = 0; i < 3; i++) {
    fill(0);
    float y = 265 + i * 23; 
    text(issues[i], 20, y);
    fill(150);
    ellipse(140, y, 20, 20); 
    textAlign(CENTER, CENTER); 
    fill(255, 255, 255);
    text(str(i + 1), 140, y); 
    textAlign(LEFT, CENTER);
  }



  fill(0, 0, 0, 140);
  noStroke();
  rect(10 + panelWidth + panelSpacing, 210, panelWidth, 160, 20);
  
  fill(255, 255, 255, 30);
  ellipse(35 + panelWidth + panelSpacing, 235, 40, 40);
  
  fill(255);
  rect(25 + panelWidth + panelSpacing, 222, 5, 5, 2);
  rect(25 + panelWidth + panelSpacing, 230, 20, 2, 2);
  rect(25 + panelWidth + panelSpacing, 235, 20, 2, 2);
  rect(25 + panelWidth + panelSpacing, 240, 20, 2, 2);

  
  fill(255);
  textSize(20);
  text("10월 17일", 60 + panelWidth + panelSpacing, 235);
  
  textSize(14);
  fill(255, 100, 100);
  ellipse(25 + panelWidth + panelSpacing, 265, 8, 8);
  text("미팅 11:00", 35 + panelWidth + panelSpacing, 265);
  textSize(10);
  fill(200);
  text("GS 담당자 미팅", 35 + panelWidth + panelSpacing, 280);

  fill(100, 200, 255);
  ellipse(25 + panelWidth + panelSpacing, 295, 8, 8);
  textSize(14);
  text("점검 13:00", 35 + panelWidth + panelSpacing, 295);
  textSize(10);
  fill(200);
  text("남현동 컨테이너 설비 점검", 35 + panelWidth + panelSpacing, 310);

  fill(100, 255, 100);
  ellipse(25 + panelWidth + panelSpacing, 325, 8, 8);
  textSize(14);
  text("납품 15:00", 35 + panelWidth + panelSpacing, 325);
  textSize(10);
  fill(200);
  text("페터널 - emart 천안점 납품", 35 + panelWidth + panelSpacing, 340);
  
  /*
  fill(255, 200, 100);
  ellipse(25 + panelWidth + panelSpacing, 355, 8, 8);
  textSize(14);
  text("일상 17:00", 35 + panelWidth + panelSpacing, 355);
  textSize(10);
  fill(200);
  text("디도재즈라운지 예약 @수빈", 35 + panelWidth + panelSpacing, 370);
  */
}
