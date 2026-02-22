<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>DIGIPIN Converter | Geo Address Tool</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

/* 🌈 Gradient Background */
body{
    background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
    min-height:100vh;
    color:white;
}

/* ⭐ Glass Card Effect */
.hero-card{
    max-width:650px;
    margin:auto;
    border-radius:20px;
    backdrop-filter: blur(15px);
    background: rgba(255,255,255,0.08);
    box-shadow:0 20px 50px rgba(0,0,0,0.4);
    transition: transform .3s ease;
}

.hero-card:hover{
    transform:translateY(-5px);
}

/* 🚀 Animated Button */
.start-btn{
    font-size:18px;
    padding:12px 28px;
    border-radius:30px;
    transition:all .3s ease;
}

.start-btn:hover{
    transform:scale(1.05);
    box-shadow:0 0 20px rgba(13,110,253,.6);
}

.navbar{
    background:rgba(0,0,0,0.5);
}

.footer{
    color:#ccc;
    font-size:14px;
}

</style>

</head>

<body class="pb-5">

<!-- 🔥 NAVBAR -->
<nav class="navbar navbar-dark">
<div class="container">
<span class="navbar-brand fw-bold">
🌐 DIGIPIN Converter
</span>
</div>
</nav>

<!-- ⭐ MAIN HERO SECTION -->
<div class="container text-center mt-5">

<div class="card hero-card p-5">

<h1 class="mb-3 fw-bold">
DIGIPIN Converter Tool
</h1>

<p class="mb-4 text-light">
Convert Latitude/Longitude ↔ DIGIPIN using hierarchical digital addressing.<br>
Upload CSV files, visualize results on live GIS maps, and export instantly.
</p>

<a href="${pageContext.request.contextPath}/upload.jsp"
   class="btn btn-primary btn-lg start-btn">

🚀 Start Conversion

</a>

</div>

</div>

<!-- ⭐ FOOTER -->
<div class="text-center mt-5 footer">
<small>
Built with Java Servlets • Bootstrap • Leaflet GIS • Render Cloud
</small>
</div>

</body>
</html>