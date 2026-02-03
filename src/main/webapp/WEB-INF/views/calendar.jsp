<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

        let calendar = null;

        document.addEventListener('DOMContentLoaded', function() {
            // 달력 로드
            var calendarEl = document.getElementById('calendar');
            calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                locale: 'ko', // 핵심: 한국어로 설정
                dayMaxEvents: true,      // 해당 날짜 칸을 넘어가면 "+N 더보기"로 표시
                eventDisplay: 'block',    // 이벤트를 블록 형태로 꽉 차게 표시 (말줄임표 적용에 유리)
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

                    var year = start.getFullYear(); // 연도 (2026)
                    var month = (start.getMonth() + 1).toString().padStart(2, '0'); // 월 (01)

                    var today = new Date();
                    var tYear = today.getFullYear();
                    var tMonth = (today.getMonth() + 1).toString().padStart(2, '0');
                    // 이번달인 경우 오늘 날짜로 세팅,그 외 월이 변경되는 경우 매월 1일로 세팅
                    var targetDt = '';
                    if (tYear == year && tMonth == month) {
                        targetDt = year + '-' + month + '-' + today.getDate().toString().padStart(2, '0');
                    } else {
                        targetDt = year + '-' + month + '-' + '01'
                    }
                    $("#selected-date").text(targetDt)

                    // 기존 이벤트 제거 (필요 시)
                    calendar.removeAllEvents();

                    // 💡 여기서 공공데이터 API를 호출하는 함수를 실행하세요!
                    getAnniversaryInfo(year,month);

                    // 오늘의 일정 가져오기
                    fetchDaySchedule(targetDt);

                    // 이달의 일정 가져오기
                    fetchMonthSchedules(year, month);

                }
            });
            calendar.render();
        });

        function getAnniversaryInfo(selYear, selMonth) {
            let xmlString = "";
            var xhr = new XMLHttpRequest();
            var url = 'http://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getAnniversaryInfo'; /*URL*/
            var queryParams = '?' + encodeURIComponent('serviceKey') + '='+'6ec54fd113e0a9f4a2724329c54a2ab69991850e471f6c439187be18718db269'; /*Service Key*/
            queryParams += '&' + encodeURIComponent('solYear') + '=' + encodeURIComponent(selYear);
            queryParams += '&' + encodeURIComponent('solMonth') + '=' + encodeURIComponent(selMonth);
            xhr.open('GET', url + queryParams);
            xhr.onreadystatechange = function () {
                if (this.readyState == 4) {
                    xmlString = this.responseText;

                    if (xmlString != "") {
                        const parser = new DOMParser();
                        const xmlDoc = parser.parseFromString(xmlString, "text/xml");

                        const items = xmlDoc.getElementsByTagName("item");

                        for (let i = 0; i < items.length; i++) {
                            const item = items[i];

                            // 값 추출
                            const dateName = item.getElementsByTagName("dateName")[0].textContent;
                            const isHoliday = item.getElementsByTagName("isHoliday")[0].textContent;
                            const locdate = item.getElementsByTagName("locdate")[0].textContent; // "20190228"

                            // 날짜 포맷 변환: "20190228" -> "2019-02-28"
                            const formattedYear = locdate.substring(0, 4);
                            const formattedMonth = locdate.substring(4, 6);
                            const formattedDay = locdate.substring(6, 8);

                            const formattedDate = formattedYear + '-' + formattedMonth + '-' + formattedDay;

                            // 3. FullCalendar 이벤트로 추가
                            calendar.addEvent({
                                id: 'holiday-' + locdate, // 중복 방지용 ID
                                title: dateName,
                                start: formattedDate,
                                allDay: true,

                                // 공휴일 전용 스타일 설정
                                backgroundColor: 'transparent', // 배경은 투명하게 (글자만 보이게)
                                borderColor: 'transparent',
                                textColor: '#e91e63',           // 휴일은 핑크/레드 계열
                                className: 'holiday-event',     // CSS 제어를 위한 클래스 추가

                                // 커스텀 데이터 (필요 시)
                                extendedProps: {
                                    isHoliday: isHoliday
                                }
                            });

                        }
                    }
                }
            };

            xhr.send('');
        }

        function fetchMonthSchedules(year, month) {
            const lastDay = new Date(year, month, 0).getDate();

            // 대상 월: 2026-01
            const targetMonth = year + '-' + String(month).padStart(2, '0');

            var formData = {
                  selType      : 'month'
                , selectedDate : targetMonth
            }

            $.ajax({
                url: '/calendar/selectScheduleMstAjax',
                type: 'GET',
                data: formData,
                success: function(res) {
                    if(res.status === "success") {
                        renderCalendarEvents(res.scheduleList);
                    } else {
                        alert(res.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("서버 통신 중 에러가 발생했습니다.");
                }
            });
        }

        function renderCalendarEvents(data) {
            data.forEach(item => {
                calendar.addEvent({
                    id: item.vscheduleId,
                    title: item.vtitle,
                    start: item.dtargetDtm,
                    allDay: true,
                    backgroundColor: '#3788d8',
                    borderColor: '#3788d8'
                });
            });
        }

        function renderScheduleList(data, selectedDate) {
            const $listContainer = $('#todo-list');
            $listContainer.empty();

            if (!data || data.length === 0) {
                $listContainer.append('<li class="no-data">등록된 일정이 없습니다.</li>');
                return;
            }

            // 데이터 반복문 처리
            data.forEach(item => {
                var timeDisplay = item.dtargetDtm ? item.dtargetDtm.substring(11, 16) : '--:--';
                const html = '<li class="schedule-item" data-id="'+ item.vscheduleId + '">'
                           + '  <div class="schedule-info-wrapper">'
                           + '    <div class="schedule-header">'
                           + '      <span class="time-badge">' + formatDateTime(item.dtargetDtm) + '</span>'
                           + '      <span class="schedule-title">' + (item.vtitle || '제목 없음') + '</span>'
                           + '    </div>'
                           + '    <div class="schedule-body">'
                           + '      <p class="schedule-content">' + (item.vcont || '') + '</p>'
                           + '    </div>'
                           + '  </div>'
                           + '  <div class="schedule-btns">'
                           + '    <button type="button" class="btn-edit" onclick="openEditModal(\'' + item.vscheduleId + '\', \'' + item.vtitle + '\', \'' + item.vcont + '\', \'' + selectedDate + '\', \'' + timeDisplay + '\')">수정</button>'
                           + '    <button type="button" class="btn-delete" onclick="deleteSchedule(\'' + item.vscheduleId + '\', \'' + selectedDate + '\')">삭제</button>'
                           + '  </div>'
                           + '</li>';
                $listContainer.append(html);
            });
        }

        function fetchDaySchedule(searchDate) {

            var formData = {
                  selType      : 'day'
                , selectedDate : searchDate
            }

            $.ajax({
                url: '/calendar/selectScheduleMstAjax',
                type: 'GET',
                data: formData,
                success: function(res) {
                    if(res.status === "success") {
                        renderScheduleList(res.scheduleList, searchDate);
                    } else {
                        alert(res.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("서버 통신 중 에러가 발생했습니다.");
                }
            });
        }

        function formatDateTime(isoString) {
            if (!isoString) return '시간미정';

            // T를 공백으로 바꾸고, 마침표(.) 뒷부분(밀리초)을 제거합니다.
            // '2026-01-19T06:49:39.781443' -> '2026-01-19 06:49:39'
            return isoString.replace('T', ' ').split('.')[0];
        }

        // 모달 열기
        function openModal(selectedDate) {
            $('#modalTargetDate').val(selectedDate); // 클릭된 날짜 저장
            $('#modalTitle').text(selectedDate + ' 새로운 일정');
            $('#scheduleModal').show();
        }

        // 모달 닫기
        function closeModal() {
            $('#scheduleForm')[0].reset(); // 입력값 초기화
            $('#scheduleModal').hide();
        }


        // 신규 일정 등록
        function saveSchedule() {
            const title = $('#v_title').val();
            const content = $('#v_content').val();
            const date = $('#modalTargetDate').val(); // 예: "2026-01-20"
            const time = $('#v_time').val();         // 예: "14:30"

            if (!content) {
                alert("내용을 입력해주세요.");
                return;
            }

            const targetDtm = date + ' ' + time + ':00';

            $('.btn-save').prop('disabled', true).text('저장 중...');

            var formData = {
                  vTitle     : title
                , vCont      : content
                , dTargetDtm : targetDtm
            }

            $.ajax({
                url: '/calendar/insertScheduleMst',
                type: 'POST',
                data: formData,
                success: function(res) {
                    if(res.status === "success") {
                        alert(res.message);

                        // 1. 현재 캘린더의 모든 소스를 제거
                        calendar.removeAllEvents();
                        // 이달의 일정 가져오기
                        const dateSplit = date.split('-');
                        fetchMonthSchedules(dateSplit[0], dateSplit[1]);

                        // 오늘의 일정 가져오기
                        fetchDaySchedule(date);

                        closeModal();
                    } else {
                        alert(res.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("서버 통신 중 에러가 발생했습니다.");
                }
            });

        }

        function deleteSchedule(id, selectedDate) {
            if (!confirm("이 일정을 정말 삭제하시겠습니까?")) return;

            $.ajax({
                url: '/calendar/deleteScheduleMst',
                type: 'POST',
                data: { scheduleId: id },
                success: function(res) {
                    if(res.status === "success") {
                        alert("삭제되었습니다.");
                        // 1. 현재 캘린더의 모든 소스를 제거
                        calendar.removeAllEvents();

                        // 이달의 일정 가져오기
                        const dateSplit = selectedDate.split('-');
                        fetchMonthSchedules(dateSplit[0], dateSplit[1]);

                        // 오늘의 일정 가져오기
                        fetchDaySchedule(selectedDate);
                    } else {
                        alert(res.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("서버 통신 중 에러가 발생했습니다.");
                }

            });

        }

        // 수정을 위한 모달 열기
        function openEditModal(id, title, content, date, time) {
            $('#modalTitle').text(date + " 일정 수정");
            $('#v_title').val(title);
            $('#v_content').val(content);
            $('#modalTargetDate').val(date);
            $('#v_time').val(time);

            $('#modalScheduleId').val(id);

            $('.btn-save').attr('onclick', 'updateSchedule()').text('수정 완료');

            $('#scheduleModal').fadeIn(200);
        }

        // 실제 수정 요청
        function updateSchedule() {
            const id = $('#modalScheduleId').val();
            const title = $('#v_title').val();
            const content = $('#v_content').val();
            const date = $('#modalTargetDate').val();
            const time = $('#v_time').val();
            const targetDtm = date + ' ' + time + ':00';

            $.ajax({
                url: '/calendar/updateScheduleMst',
                type: 'POST',
                data: {
                    vScheduleId: id
                  , vCont: content
                  , vTitle: title
                  , dTargetDtm: targetDtm
                },
                success: function(res) {
                    if(res.status === "success") {
                        alert("수정되었습니다.");

                        // 1. 현재 캘린더의 모든 소스를 제거
                        calendar.removeAllEvents();

                        // 오늘의 일정 세팅
                        fetchDaySchedule(date);

                        // 이달의 일정 가져오기
                        const dateSplit = date.split('-');
                        fetchMonthSchedules(dateSplit[0], dateSplit[1]);

                        closeModal();

                    } else {
                        alert(res.message);
                    }
                },
                error: function(xhr, status, error) {
                    alert("서버 통신 중 에러가 발생했습니다.");
                }

            });

        }

    </script>
</head>
<body>
    <h2>달력</h2>
    <div class="main-container">
        <%-- 달력 --%>
        <div id="calendar-wrapper">
            <div id="calendar"></div>
        </div>

        <%-- 오늘의 일정 --%>
        <div id="todo-wrapper">
            <div class="todo-header">
                <div class="header-side">
                    <h3>오늘의 일정</h3>
                </div>

                <div class="header-center">
                    <span id="selected-date"></span>
                </div>

                <div class="header-side" style="text-align: right;">
                    <button type="button" class="btn-open-modal" onclick="openModal($('#selected-date').text())">
                        + 일정 추가
                    </button>
                </div>
            </div>
            <hr>

            <ul id="todo-list">
            </ul>
        </div>
    </div>

    <%-- 일정 등록 모달 --%>
    <div id="scheduleModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3 id="modalTitle">새 일정 등록</h3>
            <hr>
            <form id="scheduleForm">
                <input type="hidden" id="modalScheduleId" />
                <input type="hidden" id="modalTargetDate">
                <div class="form-group">
                    <label>제목</label>
                    <input type="text" id="v_title" placeholder="일정 제목을 입력하세요" required>
                </div>

                <div class="form-group">
                    <label>내용</label>
                    <textarea id="v_content" rows="4" placeholder="일정 상세 내용을 입력하세요"></textarea>
                </div>

                <div class="form-group">
                    <label>시간 (HH:mm)</label>
                    <input type="time" id="v_time" value="09:00">
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-save" onclick="saveSchedule()">저장하기</button>
                    <button type="button" class="btn-cancel" onclick="closeModal()">취소</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
