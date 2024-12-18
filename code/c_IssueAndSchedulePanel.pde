import java.util.List;
import java.util.ArrayList;

void drawIssueAndSchedulePanels(float baseYOffset) {
    float panelWidth = 315; // 패널 너비
    float panelY = baseYOffset; // 패널의 Y 오프셋 위치

    // "Issues" 패널 (왼쪽)
    PImage issueImage = loadImage("../data/IssueAndSchedulePanels.png"); // 이미지 로드
    image(issueImage, 23.3, panelY, panelWidth, 150); // 왼쪽 패널 출력

    // 문제 목록
    String[] issues = {"개포동 컨테이너", "천안시 페터널", "남현동 컨테이너"};
    for (int i = 0; i < issues.length; i++) {
        fill(0); // 텍스트 색상
        textSize(12);
        textAlign(LEFT, CENTER);
        text(issues[i], 40, panelY + 55 + i * 21);

        // 원과 숫자 출력
        float circleX = 140; // 원의 X 좌표
        float circleY = panelY + 55 + i * 21; // 원의 Y 좌표
        float circleSize = 16; // 원 크기

        fill(255); // 원 배경색
        ellipse(circleX, circleY, circleSize, circleSize); // 원 그리기

        fill(0); // 숫자 색상
        textSize(10); // 숫자 텍스트 크기
        textAlign(CENTER, CENTER);
        text((((i + 2) % 3) + 1), circleX, circleY); // 숫자 출력
    }

    // "오늘 일정" 패널 (오른쪽)
    fill(255); // 텍스트 색상
    textSize(12);
    textAlign(LEFT, CENTER);

    int todayMonth = month(); // 현재 월 가져오기
    int todayDay = day();     // 현재 일 가져오기
    text(todayMonth, 228.4, panelY + 20); // "월 일" 형태로 출력
    text(todayDay, 258.4, panelY + 20); // "월 일" 형태로 출력

    String[][] schedules = initializeScheduleData();

    // 현재 날짜를 기반으로 일정 가져오기
    String[] todaySchedules;
    if (todayDay > schedules.length) {
        todaySchedules = new String[0]; // 날짜 범위를 초과한 경우 빈 배열 반환
    } else {
        todaySchedules = schedules[todayDay - 1]; // 오늘 날짜에 맞는 일정 가져오기
    }

    // 현재 시간 가져오기
    String currentTime = nf(hour(), 2) + ":" + nf(minute(), 2);

    // 일정 필터링 및 정렬
    List<String> upcomingSchedules = new ArrayList<>();
    List<String> pastSchedules = new ArrayList<>();

    for (String schedule : todaySchedules) {
        String scheduleTime = schedule.split(" ")[0]; // 시간 추출
        if (scheduleTime.compareTo(currentTime) >= 0) {
            upcomingSchedules.add(schedule); // 아직 지나지 않은 일정
        } else {
            pastSchedules.add(schedule); // 이미 지난 일정
        }
    }

    // 시간이 지난 일정과 남은 일정 결합
    upcomingSchedules.sort((a, b) -> a.split(" ")[0].compareTo(b.split(" ")[0])); // 시간 순 정렬
    pastSchedules.sort((a, b) -> a.split(" ")[0].compareTo(b.split(" ")[0]));    // 시간 순 정렬
    List<String> allSchedules = new ArrayList<>(upcomingSchedules);
    allSchedules.addAll(pastSchedules);
    
    // 전체 리스트를 시간 순서대로 정렬
    allSchedules.sort((a, b) -> a.split(" ")[0].compareTo(b.split(" ")[0]));

    // 최대 3개의 일정을 표시하기 위해 우선 지나지 않은 일정 사용
    List<String> limitedSchedules = new ArrayList<>(upcomingSchedules.size() > 3
        ? upcomingSchedules.subList(0, 3)
        : upcomingSchedules);
    
    // 만약 지나지 않은 일정이 3개 미만이라면, 지난 일정에서 채움
    if (limitedSchedules.size() < 3) {
        int remainingSlots = 3 - limitedSchedules.size();
        // 지난 일정 역순 정렬 (시간이 최근인 것부터)
        pastSchedules.sort((a, b) -> b.split(" ")[0].compareTo(a.split(" ")[0]));
    
        // 가장 최근 일정부터 추가
        List<String> additionalPastSchedules = pastSchedules.subList(0, Math.min(remainingSlots, pastSchedules.size()));
        limitedSchedules.addAll(additionalPastSchedules);
    }
    // 최종적으로 시간 순서대로 정렬
    limitedSchedules.sort((a, b) -> a.split(" ")[0].compareTo(b.split(" ")[0]));


    float scheduleStartY = panelY + 60; // 일정 시작 위치

    // 일정 출력
    for (int i = 0; i < limitedSchedules.size(); i++) {
        String schedule = limitedSchedules.get(i);
        String[] scheduleParts = schedule.split(" - ");
        String category = scheduleParts[0].split(" ")[1]; // 카테고리 (납품, 미팅, 점검, 일상)
        String time = scheduleParts[0].split(" ")[0]; // 시간
        String detail = scheduleParts[1]; // 세부 내용

        // 기본 색상 설정
        int colorToUse;
        if (category.equals("납품")) colorToUse = categoryColors[0];
        else if (category.equals("미팅")) colorToUse = categoryColors[1];
        else if (category.equals("점검")) colorToUse = categoryColors[2];
        else if (category.equals("일상")) colorToUse = categoryColors[3];
        else colorToUse = color(200); // 기타 색상
    
        // 투명도 적용
        if (pastSchedules.contains(schedule)) {
            // 이미 지난 일정은 투명도 70 적용
            fill(red(colorToUse), green(colorToUse), blue(colorToUse), 70);
        } else {
            // 지나지 않은 일정은 원래 색상 그대로
            fill(colorToUse);
        }
        
        ellipse(206, scheduleStartY - 10 + i * 32, 4.5, 4.5);

        // 텍스트 출력
        fill(pastSchedules.contains(schedule) ? color(255, 255, 255, 70) : 255); // 텍스트 투명도
        textFont(boldFont);
        textSize(12);
        text(category, 215, scheduleStartY + i * 32 - 11); // 카테고리 출력

        textFont(regularFont);
        textSize(10);
        text(time, 239, scheduleStartY + i * 32 - 10); // 시간 출력
        text(detail, 217, scheduleStartY + i * 32 + 2); // 세부 일정 출력
    }
}
