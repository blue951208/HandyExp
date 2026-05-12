<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>메인화면</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
</head>
<body>
    <%-- 상단 영역 메뉴바 --%>
    <div>
        <a href="/calendar">달력</a>
    </div>

    <h2>파일 업로드</h2>
    <form id="uploadForm" method="post" enctype="multipart/form-data">
        <input type="file" name="file" accept="image/*"/>
        <button type="button" onclick="uploadFile()">업로드</button>
    </form>
<script type="text/javascript">
    function uploadFile() {
        // file input 요소에서 파일 가져오기
        var form = $('#uploadForm')[0];
        var formData = new FormData(form);

        // ajax 요청으로 파일 업로드 처리
        $.ajax({
            url: '/file/upload',
            type: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            success: function(res) {
                if(res.status === "success") {
                    console.log("성공");
                } else {
                    console.log("실패");
                }
            },
            error: function(xhr, status, error) {
                alert("서버 통신 중 에러가 발생했습니다.");
                console.log('error : ' + error);
            }
        });


    }
</script>
</body>
</html>
