<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>Upload CSV</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-5">

<div class="card shadow-lg p-4">

<h3 class="mb-3 text-center">DIGIPIN CSV Converter</h3>

<p class="text-muted text-center">
Upload a CSV file to convert Latitude/Longitude ↔ DIGIPIN.
</p>

<form action="upload" method="post" enctype="multipart/form-data">

<div class="mb-3">
<label class="form-label">Select Conversion Mode</label>
<select name="mode" class="form-select">
<option value="encode">LatLon → DIGIPIN</option>
<option value="decode">DIGIPIN → LatLon</option>
</select>
</div>

<div class="mb-3">
<label class="form-label">Choose CSV File</label>
<input type="file" name="file" class="form-control" required>
<small class="text-muted">
Example headers: <b>lat,lon</b> or <b>digipin</b>
</small>
</div>

<div class="d-grid">
<button type="submit" class="btn btn-success btn-lg">
🚀 Convert File
</button>
</div>

</form>

<hr>

<h5 class="mt-3">Download Sample Files</h5>

<div class="d-flex gap-2">

<button class="btn btn-outline-primary"
onclick="location.href='samplecsv?type=encode'">
⬇ Sample Encode CSV
</button>

<button class="btn btn-outline-secondary"
onclick="location.href='samplecsv?type=decode'">
⬇ Sample Decode CSV
</button>

</div>

</div>

</div>

</body>
</html>