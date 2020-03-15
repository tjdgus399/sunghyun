<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>레이아웃 테스트용</title>
<!--  Jquery Mobile CSS Include  -->
<link rel="stylesheet" href="../common/style.css" />
<link rel="stylesheet" href="../common/jquery/jquery.mobile-1.0.1.css" />
<style type="text/css">
.ui-grid-b {
	
	margin : 10px;
	position : relative;
	top : 35px;
	display: center;
}

.ui-block-e {
	width: 32.5%;
	height: 200px;
	text-align: center;
	diplay : flex;
	flex:1;
	border: 1px solid;
}
</style>

<!--  Jquery Mobile JS Include  -->
<script src="../common/jquery/demos/jquery.js"></script>
<script src="../common/jquery/jquery.mobile-1.0.1.js"></script>



</head>
<body>
	<header data-role="header" data-position="fixed">
		<%@ include file="../include/headerTitle.inc"%>
	</header>

	<section data-role="section">
		<%@include file="../include/headerMenu.inc"%>

		<div class="ui grid-b">
			<div class="ui-block-e">First Column</div>

			<div class="ui-block-e">First Column</div>

			<div class="ui-block-e">First Column</div>

			<div class="ui-block-e">First Column</div>

			<div class="ui-block-e">First Column</div>

			<div class="ui-block-e">First Column</div>
			
			<div class="ui-block-e">First Column</div>
			
			<div class="ui-block-e">First Column</div>
			
			<div class="ui-block-e">First Column</div>
			
		
		</div>


	</section>

	<footer data-role="footer" data-position="fixed">
		<%@ include file="../include/footer.inc"%>
	</footer>

</body>
</html>