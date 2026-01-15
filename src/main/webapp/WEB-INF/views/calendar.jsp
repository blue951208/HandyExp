<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>메인화면</title>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=l3zon4bsqx"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/locales/ko.global.min.js"></script>
    <script>

        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko', // 핵심: 한국어로 설정
            });
            calendar.render();
        });

        let xmlString = "";
        var xhr = new XMLHttpRequest();
        var url = 'http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getAnniversaryInfo'; /*URL*/
        var queryParams = '?' + encodeURIComponent('serviceKey') + '='+'6ec54fd113e0a9f4a2724329c54a2ab69991850e471f6c439187be18718db269'; /*Service Key*/
        queryParams += '&' + encodeURIComponent('pageNo') + '=' + encodeURIComponent('1'); /**/
        queryParams += '&' + encodeURIComponent('numOfRows') + '=' + encodeURIComponent('10'); /**/
        queryParams += '&' + encodeURIComponent('solYear') + '=' + encodeURIComponent('2019'); /**/
        queryParams += '&' + encodeURIComponent('solMonth') + '=' + encodeURIComponent('02'); /**/
        xhr.open('GET', url + queryParams);
        xhr.onreadystatechange = function () {
            if (this.readyState == 4) {
                xmlString = this.responseText;
                alert('Status: '+this.status+'nHeaders: '+JSON.stringify(this.getAllResponseHeaders())+'nBody: '+this.responseText);
                console.log('xmlString : ',xmlString);

                if (xmlString != "") {
                    console.log('chk3 : ',xmlString);
                    // 2. DOMParser를 이용해 XML 파싱
                    const parser = new DOMParser();
                    const xmlDoc = parser.parseFromString(xmlString, "text/xml");

                    // 3. <item> 태그들을 모두 찾음
                    const items = xmlDoc.getElementsByTagName("item");
                    const eventList = [];

                    for (let i = 0; i < items.length; i++) {
                        const item = items[i];

                        // 값 추출
                        const dateName = item.getElementsByTagName("dateName")[0].textContent;
                        const isHoliday = item.getElementsByTagName("isHoliday")[0].textContent;
                        const locdate = item.getElementsByTagName("locdate")[0].textContent; // "20190228"

                        // 날짜 포맷 변환: "20190228" -> "2019-02-28"
                        const formattedDate = `${locdate.substring(0, 4)}-${locdate.substring(4, 6)}-${locdate.substring(6, 8)}`;

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
    </script>
</head>
<body>
    달력
    <div id='calendar'></div>
</body>
</html>
