<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>메인화면</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=l3zon4bsqx"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/locales/ko.global.min.js"></script>
    <style>
        /* 1. 일요일 날짜 및 텍스트 색상 (빨간색) */
        .fc-day-sun .fc-col-header-cell-cushion, /* 헤더(요일) */
        .fc-day-sun .fc-daygrid-day-number {      /* 날짜 */
            color: red !important;
            text-decoration: none; /* 밑줄 제거 */
        }
        /* 2. 토요일 날짜 및 텍스트 색상 (빨간색) */
        .fc-day-sat .fc-col-header-cell-cushion, /* 헤더(요일) */
        .fc-day-sat .fc-daygrid-day-number {      /* 날짜 */
            color: red !important;
            text-decoration: none; /* 밑줄 제거 */
        }

        .main-container {
            display: flex;          /* 가로 배치를 위한 플렉스 박스 */
            gap: 20px;              /* 달력과 일정 사이의 간격 */
            padding: 20px;
            align-items: flex-start; /* 높이가 달라도 상단 정렬 */
        }

        #calendar-wrapper {
            flex: 1;                /* 동일한 비율로 나눔 (50%) */
        }

        #todo-wrapper {
            flex: 1;                /* 동일한 비율로 나눔 (50%) */
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
            min-height: 500px;      /* 달력 높이와 어느 정도 맞춤 */
        }

        .todo-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        #todo-list {
            list-style: none;
            padding: 0;
        }

        #todo-list li {
            padding: 10px;
            border-bottom: 1px solid #eee;
            font-size: 14px;
        }
    </style>
    <script>

        document.addEventListener('DOMContentLoaded', function() {
            // 달력 로드
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko', // 핵심: 한국어로 설정
                dateClick: function(info) {
                    console.log('info : ',info);
                    console.log('info date : ',info.dateStr);
                    $("#selected-date").text(info.dateStr);
                },
                    // 사용자가 달력을 조작(이전/다음/보기변경)할 때마다 실행되는 핵심 이벤트
                datesSet: function(info) {
                    console.log('datesSet info : ',info);
                    // 1. 현재 달력의 제목(title)에서 연/월을 가져오는 방법 (예: "2026년 1월")
                    var currentTitle = info.view.title;

                    // 2. [추천] 날짜 객체(Date)에서 직접 추출하는 방법
                    // currentStart는 해당 뷰의 시작 날짜를 의미합니다.
                    var start = info.view.currentStart;

                    var year = start.getFullYear(); // 연도 (2026)
                    var month = (start.getMonth() + 1).toString().padStart(2, '0'); // 월 (01)

                    var today = new Date();
                    var tYear = today.getFullYear();
                    var tMonth = (today.getMonth() + 1).toString().padStart(2, '0');
                    console.log("변경된 연도: " + year);
                    console.log("변경된 월: " + month);
                    // 이번달인 경우 오늘 날짜로 세팅,그 외 월이 변경되는 경우 매월 1일로 세팅
                    if (tYear == year && tMonth == month) {
                        $("#selected-date").text(year + '-' + month + '-' + today.getDate());
                    } else {
                        $("#selected-date").text(year + '-' + month + '-' + '01');
                    }
                    // 💡 여기서 공공데이터 API를 호출하는 함수를 실행하세요!
                    getAnniversaryInfo(year,month);
                }
            });
            calendar.render();
        });

        function getAnniversaryInfo(selYear, selMonth) {
            let xmlString = "";
            var xhr = new XMLHttpRequest();
            var url = 'http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getAnniversaryInfo'; /*URL*/
            var queryParams = '?' + encodeURIComponent('serviceKey') + '='+'6ec54fd113e0a9f4a2724329c54a2ab69991850e471f6c439187be18718db269'; /*Service Key*/
            // queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); /**/
            // queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('10'); /**/
            queryParams += '&' + encodeURIComponent('solYear') + '=' + encodeURIComponent(selYear); /**/
            queryParams += '&' + encodeURIComponent('solMonth') + '=' + encodeURIComponent(selMonth); /**/
            xhr.open('GET', url + queryParams);
            xhr.onreadystatechange = function () {
                if (this.readyState == 4) {
                    xmlString = this.responseText;
                    // alert('Status: '+this.status+'nHeaders: '+JSON.stringify(this.getAllResponseHeaders())+'nBody: '+this.responseText);

                    if (xmlString != "") {
                        // 2. DOMParser를 이용해 XML 파싱
                        const parser = new DOMParser();
                        const xmlDoc = parser.parseFromString(xmlString, "text/xml");

                        // 3. <item> 태그들을 모두 찾음
                        const items = xmlDoc.getElementsByTagName("item");
                        const eventList = [];

                        $('#calendar').find('.holiday-label').remove();

                        for (let i = 0; i < items.length; i++) {
                            const item = items[i];

                            // 값 추출
                            const dateName = item.getElementsByTagName("dateName")[0].textContent;
                            const isHoliday = item.getElementsByTagName("isHoliday")[0].textContent;
                            const locdate = item.getElementsByTagName("locdate")[0].textContent; // "20190228"
                            // console.log('locdate : '+locdate+'dateName : '+dateName+'isHoliday : '+isHoliday);

                            // 날짜 포맷 변환: "20190228" -> "2019-02-28"
                            const formattedYear = locdate.substring(0, 4);
                            const formattedMonth = locdate.substring(4, 6);
                            const formattedDay = locdate.substring(6, 8);

                            const formattedDate = formattedYear + '-' + formattedMonth + '-' + formattedDay;

                            var targetDtTag = $("#calendar").find('td[data-date="'+ formattedDate +'"');
                            var html = '<div class="holiday-label" font-size: 12px; padding: 2px;">' + dateName + '</div>';

                            // 현재 선택한 년,월에 해당하는 날짜만 노출
                            console.log('formattedYear : '+formattedYear + '/ selYear : '+selYear);
                            console.log('formattedMonth : '+formattedMonth + '/ selMonth : '+selMonth);

                            if (formattedYear == selYear && formattedMonth == selMonth) {
                                targetDtTag.find("div.fc-daygrid-day-frame").append(html);
                            }
                            // 주말인 경우 제외, 휴일이 아닌 경우 제외
                            if (targetDtTag.hasClass("fc-day-sat") || targetDtTag.hasClass("fc-day-sun")
                                || isHoliday === "N") {

                            } else {
                                $("#calendar").find('td[data-date="'+ formattedDate +'"').css("color", "red !important");
                            }

                            console.log('formattedDate : ',formattedDate);

                            // 4. FullCalendar 규격에 맞는 JSON 객체 생성
                            eventList.push({
                                title: dateName,
                                start: formattedDate,
                                allDay: true,
                                // 휴일 여부에 따른 색상 지정 (기획적 디테일)
                                color: isHoliday === 'Y' ? '#ff0000' : '#888888',
                                textColor: '#ffffff'
                            });
                        }

                        console.log(eventList);

                    }
                }
            };

            xhr.send('');
        }

    </script>
</head>
<body>
    달력
    <div class="main-container">
        <div id="calendar-wrapper">
            <div id="calendar"></div>
        </div>

        <div id="todo-wrapper">
            <div class="todo-header">
                <h3>오늘의 일정</h3>
                <span id="selected-date"></span>
            </div>
            <hr>
            <ul id="todo-list">
                <li>등록된 일정이 없습니다.</li>
            </ul>
        </div>
    </div>
</body>
</html>
