<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>Upload CSV | DIGIPIN Converter</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<style>

body{
    background:#f4f6f9;
}

/* Upload Card */
.upload-card{
    max-width:700px;
    margin:auto;
    border-radius:15px;
}

/* Drag Drop Area */
.drop-zone{
    border:2px dashed #0d6efd;
    border-radius:12px;
    padding:40px;
    text-align:center;
    background:#ffffff;
    transition:0.3s;
    cursor:pointer;
}

.drop-zone.dragover{
    background:#e9f2ff;
    border-color:#198754;
}

.file-name{
    font-weight:600;
    color:#198754;
}

</style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-dark">
<div class="container">
<span class="navbar-brand">DIGIPIN Converter</span>
</div>
</nav>

<div class="container mt-5">

<div class="card shadow-lg p-4 upload-card">

<h3 class="text-center mb-3">📂 Upload CSV File</h3>

<p class="text-muted text-center">
Upload CSV with headers:
<b>uid,Latitude,Longitude</b> or <b>uid,digipin</b>
</p>

<form action="upload" method="post" enctype="multipart/form-data">

<!-- MODE -->
<div class="mb-3">
<label class="form-label fw-bold">Conversion Mode</label>
<select name="mode" class="form-select">
<option value="encode">Latitude/Longitude → DIGIPIN</option>
<option value="decode">DIGIPIN → Latitude/Longitude</option>
</select>
</div>

<!-- DRAG DROP AREA -->
<div id="dropZone" class="drop-zone mb-3">
<p class="mb-2">⬇ Drag & Drop CSV Here</p>
<p class="text-muted">or click to choose file</p>

<input type="file" name="file" id="fileInput"
class="form-control d-none" required>

<div id="fileName" class="file-name mt-2"></div>

</div>

<div class="d-grid">
<button type="submit" class="btn btn-success btn-lg">
🚀 Convert File
</button>
</div>

</form>

<hr>

<h5>Sample Files</h5>

<button class="btn btn-outline-primary me-2"
onclick="location.href='samplecsv?type=encode'">
Sample Encode CSV
</button>

<button class="btn btn-outline-secondary"
onclick="location.href='samplecsv?type=decode'">
Sample Decode CSV
</button>

</div>
</div>

<script>

// Elements
const dropZone = document.getElementById("dropZone");
const fileInput = document.getElementById("fileInput");
const fileName = document.getElementById("fileName");

// Click to open file chooser
dropZone.addEventListener("click", () => fileInput.click());

// File selected
fileInput.addEventListener("change", function(){
    if(this.files.length > 0){
        fileName.textContent = "Selected: " + this.files[0].name;
    }
});

// Drag Over
dropZone.addEventListener("dragover", function(e){
    e.preventDefault();
    dropZone.classList.add("dragover");
});

// Drag Leave
dropZone.addEventListener("dragleave", function(){
    dropZone.classList.remove("dragover");
});

// Drop file
dropZone.addEventListener("drop", function(e){
    e.preventDefault();
    dropZone.classList.remove("dragover");

    fileInput.files = e.dataTransfer.files;

    if(fileInput.files.length > 0){
        fileName.textContent = "Selected: " + fileInput.files[0].name;
    }
});

</script>

</body>
</html>