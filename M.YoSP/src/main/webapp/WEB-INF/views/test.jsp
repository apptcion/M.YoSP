<!DOCTYPE html>
<html lang="en">
<head>
<title>CSS Template</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
$(function(){
	
	
	var fileDrop = document.querySelector('.drop');
	
    fileDrop.addEventListener('drop', function(e) {
    	e.preventDefault();
		var count = $(".output").length;
		console.log(count);
		console.log(typeof count);
		count = count + 1;
		$(".drop").append("<img class='output imgNum" + count +"'>")
		readDropFile(e.dataTransfer.files[0], count);
 		
    });
	
   	fileDrop.addEventListener('dragover', function(e) {
        e.preventDefault();
        
        var vaild = e.dataTransfer.types.indexOf('Files') >= 0;
        $(this).css("border","dashed 1.5px green")
    });
   	
   	fileDrop.addEventListener('dragleave', function(e){
   		$(this).css("border","dashed 1.5px black")
   	})
})
</script>
<style>
.drop {
	border: dashed 1px black;
	width: 400px;
	height: 400px;
}

img {
	object-fit: cover; 
	width: 200px;
	height: 200px;
}
</style>
</head>
<body>
		<input type='file' accept='image/*' class="input" multiple><br>
		<div class="drop">
		<img class="output imgNum1" src="">
		</div>

</body>
<script>
	function readFile(input, num) {
		var reader = new FileReader();
		num = num - 1
		reader.onload = function(e) {
			$('.imgNum' + num).attr('src', e.target.result);
		}
		console.log(input.files[0]);
		reader.readAsDataURL(input.files[0]);
	}
	
	function readDropFile(file,num){
		var reader = new FileReader();
		num = num - 1
		reader.onload = function(e) {
			$('.imgNum' + num).attr('src', e.target.result);
		}
		console.log(file);
		reader.readAsDataURL(file);
	}

	$(function() {
		$(".input").change(function() {
			var count = $(".output").length;
			console.log(count);
			console.log(typeof count);
			count = count + 1;
			$(".drop").append("<img class='output imgNum" + count +"'>")
			readFile(this, count);
		});

		$("#drop").on('dragenter', function(e) {
			e.preventDefault();
			e.stopPropagation();
			$(this).css("border", "dashed 1.5px green");
		})

		$("#drop").on('dragleave', function(e) {
			e.preventDefault();
			e.stopPropagation();
			$(this).css("border", "dashed 1.5px black");
		})
	})
</script>
</html>