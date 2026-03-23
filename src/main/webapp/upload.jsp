<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<title>DIGIPIN Converter</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.fullscreen@1.6.0/Control.FullScreen.css" />

<style>
  
/* Fix Bootstrap overriding Leaflet buttons */


body{
    font-family:'Poppins',sans-serif;
    background: linear-gradient(135deg,#0f2027,#203a43,#2c5364);
    color:white;
    min-height:100vh;
    background-attachment: fixed;
}

.glass-card{
    border-radius:20px;
    backdrop-filter: blur(18px);
    background: rgba(255,255,255,0.08);
    box-shadow:0 25px 60px rgba(0,0,0,0.5);
    padding:35px;
    transition:.3s ease;
    height: 100%;
    overflow: visible;
    
    
    
}

.glass-card:hover{
    transform:translateY(-4px);
    box-shadow:0 30px 70px rgba(0,0,0,0.6),
               0 0 20px rgba(0,150,255,0.3);
}

.section-title{
    font-weight:600;
    margin-bottom:20px;
}

.form-control, .form-select{
    border-radius:12px;
}

.btn{
    border-radius:30px;
    transition:.3s ease;
}
.detect-btn{
    padding:12px 20px;
    font-weight:600;
    font-size:15px;
    border-radius:40px;
    border:none;

    background:linear-gradient(135deg,#2f80ff,#1a5edc);
    color:white;

    box-shadow:0 8px 25px rgba(0,102,255,.35);
    transition:.25s ease;
}

.detect-btn:hover{
    transform:translateY(-2px);
    box-shadow:0 12px 30px rgba(0,102,255,.5);
}

.reset-btn{
    padding:12px 20px;
    font-weight:600;
    font-size:15px;
    border-radius:40px;

    background:transparent;
    border:2px solid #ff4d4d;
    color:#ff4d4d;

    transition:.25s ease;
}

.reset-btn:hover{
    background:#ff4d4d;
    color:white;
    transform:translateY(-2px);
}
.btn:hover{
    transform:translateY(-2px);
}

#singleMap{
    height:280px;
    border-radius:18px;
    margin-top:15px;
}
</style>
</head>

<body>

<div class="container py-5">

<h2 class="text-center mb-5 fw-bold">DIGIPIN Converter</h2>

<div class="row g-5">

<!-- ================= LEFT: BATCH ================= -->
<div class="col-lg-6">

<div class="glass-card mb-5">

<h4 class="section-title">📂 Batch CSV Conversion</h4>

<p class="text-light">
Required headers:
<b>uid,Latitude,Longitude</b> OR <b>uid,digipin</b>
</p>

<form action="upload" method="post" enctype="multipart/form-data">

<div class="mb-3">
<label>Select Mode</label>
<select name="mode" class="form-select">
<option value="encode">Latitude Longitude → DIGIPIN</option>
<option value="decode">DIGIPIN → Latitude Longitude</option>
</select>
</div>

<div class="mb-3">
<label>Upload CSV File</label>
<input type="file" name="file" class="form-control" required>
</div>

<div class="d-grid">
<button type="submit" class="btn btn-success btn-lg">
🚀 Convert File
</button>
</div>

</form>

<hr class="my-4">

<h6>Sample Templates</h6>

<div class="d-flex gap-2 flex-wrap">
<button class="btn btn-outline-light"
onclick="location.href='samplecsv?type=encode'">
⬇ To Digipin
</button>

<button class="btn btn-outline-light"
onclick="location.href='samplecsv?type=decode'">
⬇ To Latitude,Longitude
</button>
</div>

</div>
</div>

<!-- ================= RIGHT: SINGLE ================= -->
<div class="col-lg-6">

<div class="glass-card">

<h4 class="section-title">⚡ Quick Single Conversion</h4>

<div class="row g-3">

<div class="col-md-6">
<input type="text" id="singleLat" class="form-control"
placeholder="Latitude (22.5726)">
</div>

<div class="col-md-6">
<input type="text" id="singleLon" class="form-control"
placeholder="Longitude (88.3639)">
</div>

<div class="col-12">
    <input type="text" id="singleDigipin" class="form-control"
           placeholder="DIGIPIN (FC9-M7M-7JFK)">
</div>


</div>

<div class="col-12">
<div id="singleResult"
class="alert alert-info d-none d-flex justify-content-between align-items-center">

    <span id="resultText"></span>

    <button id="copyBtn"
            class="btn btn-sm btn-outline-dark ms-3"
            onclick="copyResult()">
        📋 Copy
    </button>

</div>
</div>
<div class="col-12 mt-3">
    <div class="row g-3">
        <div class="col-6">
            <button class="btn detect-btn w-100"
                    onclick="detectMyLocation()">
                📍 Detect Location
            </button>
        </div>

        <div class="col-6">
            <button class="btn reset-btn w-100"
                    onclick="resetMap()">
                ♻ Reset
            </button>
        </div>
        <div class="col-12">
            <h6 class="text-light mt-3 mb-2">
     Calculate The Road Distance (Choose Your Travel Mode)
</h6>
            
    <div class="d-flex gap-2">
    <button id="carBtn" class="btn btn-success w-50"
        onclick="calculateRoute('DRIVING')">
        🚗 Car
    </button>

    <button id="walkBtn" class="btn btn-secondary w-50"
        onclick="calculateRoute('WALKING')">
        🚶 Walk
    </button>
</div>
            
<!-- ✅ CORRECT PLACEMENT -->
<div class="mt-3">
    <button id="navBtn"
        class="btn btn-primary w-100"
        disabled
        onclick="openGoogleMapsNavigation()">
        🧭 Open in Google Maps
    </button>
</div>
</div>          
</div>
    </div>
</div>   

</div>

<div id="singleMap"></div>

</div>
</div>

</div>
</div>

<!-- ================= MAP + JS ================= -->

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.fullscreen@1.6.0/Control.FullScreen.js"></script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyArzYwAK0Oa_5pvGc_K3w76aeDhSuhs1nk"></script>
<script>
let currentSource = null;
let currentDestination = null;
let currentMode = "DRIVING";
// ===== MINI MAP =====
var singleMap = L.map('singleMap', {
    zoomControl: false,   // disable default zoom
    fullscreenControl: true,
    fullscreenControlOptions: {
        position: 'topright'   // fullscreen on right
    }
}).setView([22.9734,78.6569],5);

// Add zoom separately on left
L.control.zoom({
    position: 'topleft'
}).addTo(singleMap);

singleMap.on('enterFullscreen', function(){
    singleMap.invalidateSize();
});

singleMap.on('exitFullscreen', function(){
    singleMap.invalidateSize();
});


// ===== BASE MAPS =====

var osm = L.tileLayer(
'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
{ attribution:'© OpenStreetMap contributors' }
).addTo(singleMap);

var dark = L.tileLayer(
'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
{ attribution:'© CartoDB' }
);

var terrain = L.tileLayer(
'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
{ attribution:'© OpenTopoMap' }
);

// ESRI Satellite
var esriSat = L.tileLayer(
'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
{ attribution:'Tiles © Esri' }
);

// ESRI Streets
var esriStreets = L.tileLayer(
'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
{ attribution:'Tiles © Esri' }
);

// ESRI Hybrid (Satellite + Labels)
// ESRI Hybrid (Satellite + Labels)
var esriHybrid = L.layerGroup([
    L.tileLayer(
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        { attribution:'Tiles © Esri' }
    ),
    L.tileLayer(
        'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}'
    )
]);

// ===== Layer Control =====

L.control.layers({
    "🌍 OpenStreetMap": osm,
    "🌃 Dark Mode": dark,
    "🗺 Terrain": terrain,
    "🛰 ESRI Satellite": esriSat,
    "🌆 ESRI Streets": esriStreets,
    "🧭 Hybrid": esriHybrid
}).addTo(singleMap);
L.control.scale().addTo(singleMap);

singleMap.on("click", function(e){

    var lat = e.latlng.lat.toFixed(6);
    var lon = e.latlng.lng.toFixed(6);

    document.getElementById("singleLat").value = lat;
    document.getElementById("singleLon").value = lon;

    fetch("singleconvert?mode=encode&lat=" 
         + encodeURIComponent(lat) 
         + "&lon=" 
         + encodeURIComponent(lon))
    .then(r=>{
        if(!r.ok) throw new Error("Server Error");
        return r.text();
    })
    .then(data=>{
        showResult("DIGIPIN: " + data);
        showMarker(lat, lon, data);
    })
    .catch(err=>{
        showResult("Error: " + err.message);
    });

});

var singleMarker = null;

// LAT,LON → DIGIPIN
document.getElementById("singleLon").addEventListener("change",function(){

 let lat=document.getElementById("singleLat").value;
 let lon=document.getElementById("singleLon").value;

 if(lat && lon){

 fetch("singleconvert?mode=encode&lat=" 
      + encodeURIComponent(lat) 
      + "&lon=" 
      + encodeURIComponent(lon))
 .then(r=>{
     if(!r.ok) throw new Error("Server Error");
     return r.text();
 })
 .then(data=>{
     showResult("DIGIPIN: "+data);
     showMarker(lat,lon,data);
 })
 .catch(err=>{
     showResult("Error: " + err.message);
 });

 }
});

// DIGIPIN → LAT,LON
document.getElementById("singleDigipin").addEventListener("change",function(){

 let dp=this.value;

 if(dp){

 fetch("singleconvert?mode=decode&digipin=" 
      + encodeURIComponent(dp))
.then(r=>{
    if(!r.ok) throw new Error("Server Error");
    return r.text();
})
.then(data=>{
    showResult("Latitude,Longitude: "+data);

    if(data.includes(",")){
        let arr=data.split(",");
        showMarker(arr[0],arr[1],dp);
    }
})
.catch(err=>{
    showResult("Error: " + err.message);
});
 }
});

function showResult(msg){

 let box = document.getElementById("singleResult");
 let text = document.getElementById("resultText");

 box.classList.remove("d-none");
 text.innerText = msg;   // safer than innerHTML
}
function copyResult(){

 let text = document.getElementById("resultText").innerText;

 if(!text) return;

 // Extract only value part after colon
 let value = text.includes(":")
     ? text.split(":")[1].trim()
     : text;

 navigator.clipboard.writeText(value).then(function(){

     let btn = document.getElementById("copyBtn");
     btn.innerText = "✅ Copied";

     setTimeout(function(){
         btn.innerText = "📋 Copy";
     },1500);

 });

}
function showMarker(lat, lon, label){

 if(singleMarker){
   singleMap.removeLayer(singleMarker);
 }

 singleMarker = L.marker([lat, lon], {
     draggable: true
 }).addTo(singleMap);

 singleMarker.bindPopup(
"<div style='font-weight:600;margin-bottom:4px'>DIGIPIN - "+label+"</div>"+
"<div>Latitude : "+Number(lat).toFixed(6)+"</div>"+
"<div>Longitude : "+Number(lon).toFixed(6)+"</div>"
).openPopup();

 singleMap.flyTo([lat, lon], 14,{
duration:1.4,
easeLinearity:0.25
});

 // 🔥 When marker is dragged
singleMarker.on("dragend", function(e){

    var newLat = e.target.getLatLng().lat.toFixed(6);
    var newLon = e.target.getLatLng().lng.toFixed(6);

    document.getElementById("singleLat").value = newLat;
    document.getElementById("singleLon").value = newLon;

    fetch("singleconvert?mode=encode&lat=" 
         + encodeURIComponent(newLat) 
         + "&lon=" 
         + encodeURIComponent(newLon))
    .then(r=>{
        if(!r.ok) throw new Error("Server Error");
        return r.text();
    })
    .then(data=>{
        showResult("DIGIPIN: " + data);
        singleMarker.setPopupContent(
"<div style='font-weight:600;margin-bottom:4px'>DIGIPIN - "+data+"</div>"+
"<div>Latitude : "+Number(newLat).toFixed(6)+"</div>"+
"<div>Longitude : "+Number(newLon).toFixed(6)+"</div>"
).openPopup();
    })
    .catch(err=>{
        showResult("Error: " + err.message);
    });

});   // ✅ closes dragend

}
// ===== DETECT MY LOCATION =====
function detectMyLocation(){

 if(!navigator.geolocation){
   alert("Geolocation not supported by your browser");
   return;
 }

 navigator.geolocation.getCurrentPosition(function(position){

   let lat = position.coords.latitude.toFixed(6);
   let lon = position.coords.longitude.toFixed(6);

   // Fill input boxes
   document.getElementById("singleLat").value = lat;
   document.getElementById("singleLon").value = lon;

   // Call backend to get DIGIPIN
   fetch("singleconvert?mode=encode&lat=" 
      + encodeURIComponent(lat) 
      + "&lon=" 
      + encodeURIComponent(lon))
.then(r=>{
    if(!r.ok) throw new Error("Server Error");
    return r.text();
})
.then(data=>{
    showResult("DIGIPIN: "+data);
    showMarker(lat,lon,data);
})
.catch(err=>{
    showResult("Error: " + err.message);
});

 }, function(error){

   alert("Location access denied or unavailable.");

 });

}
function resetMap(){
    
    currentSource = null;
currentDestination = null;
currentMode = "DRIVING";
document.getElementById("navBtn").disabled = true;
    // Clear input fields
    document.getElementById("singleLat").value = "";
    document.getElementById("singleLon").value = "";
    document.getElementById("singleDigipin").value = "";

    // Hide result box
    var box = document.getElementById("singleResult");
    box.classList.add("d-none");
    document.getElementById("resultText").innerText = "";

    // Remove single marker
    if(singleMarker){
        singleMap.removeLayer(singleMarker);
        singleMarker = null;
    }

    // ✅ REMOVE ROUTE LINE
    if(routeLine){
        singleMap.removeLayer(routeLine);
        routeLine = null;
    }

    // ✅ REMOVE ROUTE MARKERS
    routeMarkers.forEach(m => singleMap.removeLayer(m));
    routeMarkers = [];

    // Reset map view
    singleMap.setView([22.9734,78.6569],5);
    highlightMode("RESET");
}
function calculateRoute(mode){
    highlightMode(mode);

// STEP 1: Ask Source Type
let srcType = prompt("Enter Source Type:\n1 = DIGIPIN\n2 = Latitude/Longitude");

let sLat, sLon;

// STEP 2: Get Source
if(srcType == "1"){

    let srcDP = prompt("Enter Source DIGIPIN:");

    let res = fetch("singleconvert?mode=decode&digipin=" + encodeURIComponent(srcDP));

    // wait response
    res.then(r => r.text()).then(data => {

    if(data.includes("Incorrect") || data.includes("Error")){
        alert("Invalid Source DIGIPIN");
        return;
    }

    let s = data.split(",");
        sLat = s[0];
        sLon = s[1];

        getDestinationAndRoute(sLat, sLon, srcDP, mode);

    });

}else if(srcType == "2"){

    sLat = prompt("Enter Source Latitude:")?.trim();
sLon = prompt("Enter Source Longitude:")?.trim();

if(isNaN(sLat) || isNaN(sLon)){
    alert("Invalid Source Coordinates");
    return;
}

    let srcLabel = sLat + "," + sLon;
getDestinationAndRoute(sLat, sLon, srcLabel, mode);

}else{
    alert("Invalid choice");
}
}

let routeLine;
let routeMarkers = [];

function drawRoute(path, sLat, sLon, dLat, dLon, distance, srcDP, destDP, mode){

    // Remove old route
    if(routeLine){
        singleMap.removeLayer(routeLine);
    }

    // Remove old markers
    routeMarkers.forEach(m => singleMap.removeLayer(m));
    routeMarkers = [];
    // remove single conversion marker also
if(singleMarker){
    singleMap.removeLayer(singleMarker);
    singleMarker = null;
}

    let latlngs = path.map(p => [p.lat(), p.lng()]);

    let color = (mode === "WALKING") ? "green" : "blue";

routeLine = L.polyline(latlngs, {
    color: color,
    weight: 5
}).addTo(singleMap);

    // Source marker (green)
    let src = L.marker([sLat, sLon], {
        icon: L.icon({
            iconUrl: 'https://maps.google.com/mapfiles/ms/icons/green-dot.png',
            iconSize: [32,32]
        })
    }).addTo(singleMap);

    // Destination marker (red)
    let dest = L.marker([dLat, dLon], {
        icon: L.icon({
            iconUrl: 'https://maps.google.com/mapfiles/ms/icons/red-dot.png',
            iconSize: [32,32]
        })
    }).addTo(singleMap);

    routeMarkers.push(src, dest);

   let icon = (mode === "WALKING") ? "🚶" : "🚗";
let modeText = (mode === "WALKING") ? "Walking" : "Driving";

dest.bindPopup(
    "📍 Source: " + srcDP +
"<br>📍 Destination: " + destDP +
"<br>📌 Source Coordinates: " + Number(sLat).toFixed(6) + "," + Number(sLon).toFixed(6) +
"<br>📌 Destination Coordinates: " + Number(dLat).toFixed(6) + "," + Number(dLon).toFixed(6) +
    "<br>" + icon + " Mode: " + modeText +
    "<br>📏 Distance: " + distance
).openPopup();

    singleMap.fitBounds(routeLine.getBounds());
}
function runGoogleRoute(sLat, sLon, dLat, dLon, srcDP, destDP, mode){
    // ✅ STORE FOR GOOGLE NAVIGATION
    currentSource = {
    lat: parseFloat(sLat),
    lon: parseFloat(sLon)
};

currentDestination = {
    lat: parseFloat(dLat),
    lon: parseFloat(dLon)
};
    currentMode = mode;
    showResult("Calculating route...");

let directionsService = new google.maps.DirectionsService();

directionsService.route({
    origin: {lat: parseFloat(sLat), lng: parseFloat(sLon)},
    destination: {lat: parseFloat(dLat), lng: parseFloat(dLon)},
    travelMode: mode
}, function(result, status){

    if(status === "OK"){
        document.getElementById("navBtn").disabled = false;
        let leg = result.routes[0].legs[0];
let distance = leg.distance.text + " • " + leg.duration.text;

        drawRoute(
    result.routes[0].overview_path,
    sLat, sLon,
    dLat, dLon,
    distance,
    srcDP, destDP,
    mode   // ✅ ADD THIS
);

    }else{
        alert("Route not found");
    }

});
}
function getDestinationAndRoute(sLat, sLon, srcLabel, mode){

let destType = prompt("Enter Destination Type:\n1 = DIGIPIN\n2 = Latitude/Longitude");

let dLat, dLon, destLabel;

if(destType == "1"){

    let destDP = prompt("Enter Destination DIGIPIN:");

    fetch("singleconvert?mode=decode&digipin=" + encodeURIComponent(destDP))
    .then(r => r.text())
    .then(data => {

    // ✅ ADD THIS CHECK
    if(data.includes("Incorrect") || data.includes("Error")){
        alert("Invalid Destination DIGIPIN");
        return;
    }

    let d = data.split(",");
    dLat = d[0];
    dLon = d[1];

    runGoogleRoute(sLat, sLon, dLat, dLon, srcLabel, destDP, mode);

});

}else if(destType == "2"){

    dLat = prompt("Enter Destination Latitude:")?.trim();
dLon = prompt("Enter Destination Longitude:")?.trim();

if(isNaN(dLat) || isNaN(dLon)){
    alert("Invalid Destination Coordinates");
    return;
}

    let destLabel = dLat + "," + dLon;
runGoogleRoute(sLat, sLon, dLat, dLon, srcLabel, destLabel, mode);

}else{
    alert("Invalid choice");
}
}
function highlightMode(mode){

    let car = document.getElementById("carBtn");
    let walk = document.getElementById("walkBtn");

    // ✅ RESET MODE
    if(mode === "RESET"){
        car.classList.remove("btn-warning");
        walk.classList.remove("btn-warning");

        car.classList.add("btn-success");
        walk.classList.add("btn-secondary");
        return;
    }

    // normal logic
    car.classList.remove("btn-warning");
    walk.classList.remove("btn-warning");

    car.classList.add("btn-success");
    walk.classList.add("btn-secondary");

    if(mode === "DRIVING"){
        car.classList.remove("btn-success");
        car.classList.add("btn-warning");
    }else{
        walk.classList.remove("btn-secondary");
        walk.classList.add("btn-warning");
    }
}
let navWindow = null;

function openGoogleMapsNavigation(){

    if(!currentSource || !currentDestination){
        alert("Please calculate route first");
        return;
    }

    let mode = currentMode === "WALKING" ? "walking" : "driving";

    let url = "https://www.google.com/maps/dir/?api=1"
        + "&origin=" + currentSource.lat + "," + currentSource.lon
        + "&destination=" + currentDestination.lat + "," + currentDestination.lon
        + "&travelmode=" + mode;

    if(navWindow && !navWindow.closed){
        navWindow.location.href = url;
        navWindow.focus();
    }else{
        navWindow = window.open(url, "_blank");
    }
}
</script>

</body>
</html>


