<!DOCTYPE html>
<html lang="en">
<head>
<title>CSS Template</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=	a4deef496ca0e06141a54eeea561a0d9"></script>
</head>
<body>

    <div id="kakao_map" style="margin: 0 auto; width: 100%; height: 600px"></div>


<script>
var container = document.getElementById('kakao_map');
var options = {
    center: new kakao.maps.LatLng(33.450701, 126.570667),// 지도의 중심좌표
    level: 3 // 지도의 확대 레벨
};

var map = new kakao.maps.Map(container, options);
</script>
</body>
</html>