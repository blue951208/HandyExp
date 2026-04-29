<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>메인화면</title>
</head>
<body>
    <%-- 상단 영역 메뉴바 --%>
    <div>
        <a href="/calendar">달력</a>
    </div>

    <h2>파일 업로드</h2>
    <form action="/file/upload" method="post" enctype="multipart/form-data">
        <input type="file" name="file" />
        <button type="submit">업로드</button>
    </form>
</body>
</html>
