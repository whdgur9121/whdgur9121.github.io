<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:useBean id="calc" class = "ch07.Calculator"/>
<jsp:setProperty name = "calc" property="*" />

<%@ taglib prefix ="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h2>계산 결과-usebean</h2>
	<hr>
	결과: <%=calc.calc() %>
	<hr>
	<c:if test="${msg == 'user1' }" var="result">
		test result : ${result}"
	</c:if>
</body>
</html>