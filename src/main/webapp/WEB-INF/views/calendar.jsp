<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>메인화면</title>
    <link rel="stylesheet" href="/resources/css/calendar.css">
    <%-- jQuery --%>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <%-- supabase --%>
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <%-- 지도 --%>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=l3zon4bsqx"></script>
    <%-- 달력 --%>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/locales/ko.global.min.js"></script>
    <script>

        // 1. 접속 정보 설정
        const SUPABASE_URL = 'https://bvukavwhtdgxgwlglenv.supabase.co';
        const SUPABASE_KEY = 'sb_publishable_IWeD_C_wgH1kir6DEzjVtw__Ukkva81';
        const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

        document.addEventListener('DOMContentLoaded', function() {
            // 달력 로드
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko', // 핵심: 한국어로 설정
                dateClick: function(info) {
                    $("#selected-date").text(info.dateStr);
                    // 오늘의 일정 가져오기
                    fetchDaySchedule(info.dateStr);
                },
                    // 사용자가 달력을 조작(이전/다음/보기변경)할 때마다 실행되는 핵심 이벤트
                datesSet: function(info) {
                    // 1. 현재 달력의 제목(title)에서 연/월을 가져오는 방법 (예: "2026년 1월")
                    var currentTitle = info.view.title;

                    // 2. [추천] 날짜 객체(Date)에서 직접 추출하는 방법
                    // currentStart는 해당 뷰의 시작 날짜를 의미합니다.
                    var start = info.view.currentStart;
                    console.log('start : ',start);

                    var year = start.getFullYear(); // 연도 (2026)
                    var month = (start.getMonth() + 1).toString().padStart(2, '0'); // 월 (01)

                    var today = new Date();
                    var tYear = today.getFullYear();
                    var tMonth = (today.getMonth() + 1).toString().padStart(2, '0');
                    // 이번달인 경우 오늘 날짜로 세팅,그 외 월이 변경되는 경우 매월 1일로 세팅
                    var targetDt = '';
                    if (tYear == year && tMonth == month) {
                        targetDt = year + '-' + month + '-' + today.getDate();
                    } else {
                        targetDt = year + '-' + month + '-' + '01'
                    }
                    $("#selected-date").text(targetDt)
                    // 💡 여기서 공공데이터 API를 호출하는 함수를 실행하세요!
                    getAnniversaryInfo(year,month);

                    // 오늘의 일정 가져오기
                    fetchDaySchedule(targetDt);
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
                            if (formattedYear == selYear && formattedMonth == selMonth) {
                                targetDtTag.find("div.fc-daygrid-day-frame").append(html);
                            }
                            // 주말인 경우 제외, 휴일이 아닌 경우 제외
                            if (targetDtTag.hasClass("fc-day-sat") || targetDtTag.hasClass("fc-day-sun")
                                || isHoliday === "N") {

                            } else {
                                $("#calendar").find('td[data-date="'+ formattedDate +'"').css("color", "red !important");
                            }

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
                    }
                }
            };

            xhr.send('');
        }

        function renderScheduleList(data, selectedDate) {
            const $listContainer = $('#todo-list'); // 어제 만든 리스트 태그
            $listContainer.empty(); // 기존 리스트 비우기

            if (!data || data.length === 0) {
                $listContainer.append('<li class="no-data">등록된 일정이 없습니다.</li>');
                return;
            }

            // 데이터 반복문 처리
            data.forEach(item => {
                const html = '<li class="schedule-item" data-id="'+ item.v_schedule_id + '">'
                           + '  <div class="time">' + item.d_target_dtm + '</div>'
                           + '  <div class="title">' + item.v_cont + '</div>'
                           + '</li>';
                $listContainer.append(html);
            });
        }

        /**
         * 특정 날짜의 일정을 Supabase에서 가져오는 함수
         * @param {string} searchDate - "2026-01-19" 형식
         */
        async function fetchDaySchedule(searchDate) {
            console.log(searchDate + " 의 데이터를 불러오는 중...");

            // 2. 데이터 조회 (Select)
            const start = searchDate + 'T00:00:00';
            const end   = searchDate + 'T23:59:59';

            // console.log("요청 범위:", start, "~", end);

            const { data, error } = await supabaseClient
                .from('schedule_mst')
                .select('*')
                .gte('d_target_dtm', start) // '2026-01-19T00:00:00'
                .lte('d_target_dtm', end)   // '2026-01-19T23:59:59'
                .order('d_target_dtm', { ascending: true });

            if (error) {
                console.error("데이터 가져오기 에러:", error.message);
                alert("일정을 불러오는 데 실패했습니다.");
                return;
            }
            console.log('data : ',data);

            // 3. 화면에 데이터 뿌리기 (어제 만든 UI 함수 호출)
            renderScheduleList(data, searchDate);
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
