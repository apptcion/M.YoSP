<!DOCTYPE html>
<html lang="en">
<head>
<title>CSS Template</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$(function(){
		$("div").on('dragenter',function(e){
			e.preventDefault();
			e.stopPropagation();
			console.log("dragenter")
		})
		$("div").on('dragover',function(e){
			e.preventDefault();
			e.stopPropagation();
			console.log("drag over")
		})
		
		var div = document.querySelector("div");
		var inputFiles = $("input");
		var files = inputFiles[0].files;
		
		div.addEventListener('drop',function(e){
			e.preventDefault();
			e.stopPropagation();
			console.log(e.dataTransfer.files[0])
			console.log(inputFiles)
			console.log(files);
			prev_img(inputFiles)
			
		})
	})
	
	    function prev_img(input) {
        if(input.files && input.files[0]) {
            const reader = new FileReader()
            reader.onload = e => {
                const previewImage = document.getElementById("id_img_preview")
                previewImage.src = e.target.result
            }
            reader.readAsDataURL(input.files[0])
        }
    }
</script>
<style>
div {
	border: dashed 1px black;
	width: 400px;
	height: 400px;
}
</style>
</head>
<body>
	<input type="file" id="uploadImgUser" name="uploadImgUser" onchange="prev_img(this)"/>
	<div>drag and drop</div>
	<img src="" id="id_imd_preview">
</body>
</html>