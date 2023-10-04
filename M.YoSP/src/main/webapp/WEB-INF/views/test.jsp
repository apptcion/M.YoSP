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

var map = document.querySelector("#kakao_map")

map.addEventListener('click',async function(){
	console.log("After")
	await testCallBack();
	console.log("Before")	
})

function testCallBack(){
	return new Promise((resolve,reject) =>{
		setTimeout(() => {
			console.log("CallBack")
			resolve()
		},2000)
		
	})
}
</script>
</body>
</html>