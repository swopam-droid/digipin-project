<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>DIGIPIN Converter</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
.hero-card{
max-width:600px;
margin:auto;
}
</style>

</head>

<body class="bg-light">

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-dark">
<div class="container">
<span class="navbar-brand mb-0 h1">DIGIPIN Converter</span>
</div>
</nav>

<!-- MAIN SECTION -->
<div class="container text-center mt-5">

<div class="card shadow-lg p-5 hero-card">

<h2 class="mb-3">DIGIPIN Converter Tool</h2>

<p class="text-muted">
Convert Latitude/Longitude ↔ DIGIPIN using hierarchical digital addressing.
Upload CSV files and visualize results on an interactive map.
</p>

<a href="upload.jsp" class="btn btn-primary btn-lg mt-3">
🚀 Start Conversion
</a>

</div>

</div>

<!-- FOOTER -->
<div class="text-center mt-5 text-muted">
<small>Built with Java Servlets • Bootstrap • Leaflet GIS</small>
</div>

</body>
</html>