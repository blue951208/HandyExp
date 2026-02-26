<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>메인화면</title>
</head>
<body>
<script src="https://unpkg.com/react@18/umd/react.development.js"></script>
<script src="https://unpkg.com/react-dom@18/umd/react-dom.development.js"></script>
<script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<style>
    /* Swiper 내부 설정을 강제로 덮어쓰기 위해 클래스 선택자 사용 */
    .mySwiper .swiper-pagination {
        position: relative !important;
        margin-top: 30px !important;
        margin-bottom: 20px !important;
        bottom: 0 !important; /* absolute일 때 잡혀있던 위치 초기화 */
    }
</style>
<script type="text/babel">
    function MainDashboard() {
        const [message, setMessage] = React.useState("5년차 개발자 손동현입니다.");

        return (
        <>
            <div style={{ padding: '20px', textAlign: 'center'}}>
                <h1>{message}</h1>
            </div>
            <div style={{ display: 'flex', gap: '40px', padding: '40px' }}>
                {/* 좌측: 인적 사항 (image_b5c783.png 왼쪽 참고) */}
                <div style={{ flex: '1', borderRight: '1px solid #eee' }}>
                    <h2 style={{ fontSize: '24px', marginBottom: '20px' }}>손동현</h2>
                    <div style={{ borderLeft: '4px solid #333', paddingLeft: '15px', lineHeight: '1.8' }}>
                        <p>Tel. 010-9331-9753</p>
                        <p>Email. blue951208@naver.com</p>
                    </div>
                </div>

                <div style={{ flex: '2' }}>
                    <h3 style={{ fontSize: '20px', fontWeight: 'bold', marginBottom: '15px' }}>
                        끝까지 책임지는 5년 차 개발자 손동현입니다.
                    </h3>
                    <p style={{ color: '#666', lineHeight: '1.6', marginBottom: '20px' }}>
                        처음 접하는 기술 스택도 주저하지 않고 직접 학습하며 프로젝트에 적용해왔습니다.<br/>
                        익숙하지 않은 환경에서도 책임감을 바탕으로 끝까지 완수해온 경험이 제 강점입니다.
                    </p>

                    <h4 style={{ color: '#0056b3', borderBottom: '1px solid #0056b3', display: 'inline-block', marginBottom: '10px' }}>스킬</h4>
                    <ul style={{ listStyle: 'disc', paddingLeft: '20px', lineHeight: '2' }}>
                        <li><strong>Front-end</strong> : JSP, jQuery, JavaScript, React</li>
                        <li><strong>Back-end</strong> : Java, Spring Framework</li>
                        <li><strong>DB</strong> : PostgreSQL, Oracle, MariaDB</li>
                    </ul>
                </div>
            </div>
        </>
        );
    }

    // 경력
    function CareerBoard() {
        const { useEffect, useRef } = React;
        const swiperRef = useRef(null);

        useEffect(() => {
            // Swiper 초기화
            new Swiper('.mySwiper', {
                autoHeight: true,
                navigation: {
                    nextEl: '.swiper-button-next',
                    prevEl: '.swiper-button-prev',
                },
                pagination: {
                    el: '.swiper-pagination',
                    clickable: true,
                },
                loop: false
            });
        }, []);

        const careers = [
            {
                company: "푸드나무", startdt: "2022.12", enddt: "2025.12", services: [
                    {
                        name: "랭킹닭컴", jobs: [
                              { work: "랭킹닭컴 유지보수 및 기능 개발" }
                            , { work: "메인 전시 영역별 전시 관리 시스템 구축" }
                            , { work: "월간 이벤트 작업 및 시스템 개선" }
                            , { work: "랭킹 피트니스 작업" }
                            , { work: "랭닭 키우기 게임 작업(Phaser.js 사용)" }
                            , { work: "jsp, jQuery, Java, Spring 사용" }
                        ]
                    }
                ]
            },
            {
                company: "아이엠디글로벌스", startdt: "2020.10", enddt: "2022.11", services: [
                    {
                        name: "나의 변호사", jobs: [
                            {work: "본인인증(kcb 본인인증) 모듈 연결"},
                            {work: "React, PostgreSQL, Java 사용"}
                        ]
                    },
                    {
                        name: "중앙모자의료센터", jobs: [
                            {work: "관리자, 사용자 화면 리뉴얼"},
                            {work: "jsp, jQuery, Java, Oracle DB 사용"}
                        ]
                    },
                    {
                        name: "마음엔아트", jobs: [
                            {work: "asp 코드를 jsp, Java로 리뉴얼 작업"},
                            {work: "jsp, jQuery, Java, MariaDB 사용"}
                        ]
                    },
                    {
                        name: "아트앤하트", jobs: [
                            {work: "유지보수 및 기능 개발"},
                            {work: "망고페이 PG 연동"},
                            {work: "관리자 일부 화면 Vue.js 전환 작업"},
                            {work: "jsp, Java, MariaDB 사용"}
                        ]
                    }
                ]
            },
        ];

        return (
            <>
                <h2>경력</h2>
                <div style={{ marginTop: '30px', padding: '20px', backgroundColor: '#f9f9f9', borderRadius: '10px' }}>
                    <div className="swiper mySwiper" style={{ width: '100%', height: 'auto' }}>
                        <div className="swiper-wrapper">
                            {careers.map((item, index) => (
                                <div className="swiper-slide" key={index} style={{
                                    display: 'flex',
                                    flexDirection: 'column',
                                    justifyContent: 'center',
                                    alignItems: 'center',
                                    backgroundColor: '#fff',
                                    borderRadius: '8px',
                                    border: '1px solid #eee'
                                }}>
                                    <strong style={{ fontSize: '35px', color: '#0056b3', marginTop: '10px' }}>{item.company}</strong>
                                    <span style={{ color: '#888', fontSize: '14px' }}>{item.startdt} ~ {item.enddt}</span>
                                    <ul>
                                        {
                                            item.services.map((service, sIndex) => (
                                                <li key={sIndex} style={{ marginTop: '10px' }}>
                                                    <strong>{service.name}</strong>
                                                    <ul>
                                                        {
                                                            service.jobs.map((job, jIndex) => (
                                                                <li key={jIndex}>{job.work}</li>
                                                            ))
                                                        }
                                                    </ul>
                                                </li>
                                            ))
                                        }
                                    </ul>
                                </div>
                            ))}
                        </div>
                        {/* 네비게이션 버튼 & 페이지네이션 */}
                        <div className="swiper-button-next"></div>
                        <div className="swiper-button-prev"></div>
                        <div className="swiper-pagination" style={{position: 'relative !important', marginTop: '30px !important', marginBottom: '20px !important'}}></div>
                    </div>
                </div>
            </>
        );
    }

    function MainPage() {
        return (
          <>
              <MainDashboard/>
              <CareerBoard/>
          </>
        );
    }

    // React 18 렌더링 방식
    const root = ReactDOM.createRoot(document.getElementById('react-root'));
    root.render(<MainPage/>);
</script>
<div>
    <a href="/calendar">달력</a>
</div>
<div id="react-root">
</div>
</body>
</html>
