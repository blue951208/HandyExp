<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>메인화면</title>
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpKeyId=l3zon4bsqx"></script>
</head>
<body>
    지도 TEST
    <div id="map" style="width:100%;height:400px;"></div>
    <div>
        <a href="/calendar">달력</a>
    </div>
<script type="text/javascript">
    var mapOptions = {
        center: new naver.maps.LatLng(37.3595704, 127.105399),
        zoom: 10
    };

    var map = new naver.maps.Map('map', mapOptions);
</script>
</body>
</html>
