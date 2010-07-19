<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta name="pageName" content="species"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Species Search</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/screen.css" type="text/css" media="screen" charset="utf-8"/>
</head>
<body>
    <div id="decoratorBody">
        <div id="searchBox">
            <h2>Search for Species and Taxa</h2>
            <p>
            <p id="exampleSeaches">Examples searches:<br/><a href='${pageContext.request.contextPath}/search?q=Pogona+barbata'>Pogona barbata</a> (Eastern Bearded Dragon)<br/>
                <a href='${pageContext.request.contextPath}/search?q=Hypertropha+chlaenota'>Hypertropha chlaenota</a> (Moth - GELECHIOIDEA family)<br/>
                <a href='${pageContext.request.contextPath}/search?q=Synemon+plana'>Synemon plana</a> (Golden Sun Moth)<br/>
                <a href='${pageContext.request.contextPath}/search?q=Pygoscelis+adeliae'>Pygoscelis adeliae</a> (Adelie Penguin)<br/>
                <a href='${pageContext.request.contextPath}/search?q=Argyropelecus+gigas'>Argyropelecus gigas</a> (Giant Hatchetfish)<br/>
                <a href='${pageContext.request.contextPath}/search?q=Podargus+strigoides'>Podargus strigoides</a> (Tawny Frogmouth)<br/>
                <a href='${pageContext.request.contextPath}/search?q=Glossopsitta+concinna'>Glossopsitta concinna</a> (Musk Lorikeet)<br/>
                <a href='${pageContext.request.contextPath}/search?q=Hippotion+scrofa'>Hippotion scrofa</a> (Scrofa Hawk Moth)<br/>
                <%--<a href='${pageContext.request.contextPath}/species/search?q=Asplenium+australasicum'>Asplenium australasicum</a><br/>--%>
                <a href='${pageContext.request.contextPath}/species/search?q=Malacorhynchus+membranaceus'>Malacorhynchus membranaceus</a> (Pink-eared Duck)<br/>
            </p>
        </div>
    </div>
</body>
</html>
