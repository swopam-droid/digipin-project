<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
<title>Conversion Result</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.Default.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.fullscreen@1.6.0/Control.FullScreen.css" />

<style>
#map{height:420px;}
</style>
</head>

<body class="bg-light">

<div class="container mt-5">
<div class="card shadow p-4">

<h3 class="mb-3">Conversion Result</h3>

<p class="text-muted">
Showing first 10 records.
<button id="showAllBtn" class="btn btn-primary btn-sm" onclick="showAllRecords()">Show All</button>
<button id="showLessBtn" class="btn btn-secondary btn-sm" onclick="showLessRecords()" style="display:none;">Show Less</button>
<select id="downloadFormat" class="form-select form-select-sm d-inline w-auto ms-2">
    <option value="csv">CSV</option>
    <option value="geojson">GeoJSON</option>
    <option value="kml">KML</option>
    <option value="kmz">KMZ</option>
    <option value="shp">Shapefile</option>
    <option value="gpkg">GeoPackage</option>
</select>

<button class="btn btn-success btn-sm ms-2" onclick="downloadData()">
    ⬇ Download
</button>
<button class="btn btn-info btn-sm ms-2" onclick="scrollToMap()">
 🗺 Go To Map
</button>
</p>

<table class="table table-bordered table-striped">
<thead class="table-dark">
<tr>
<th>UID</th>
<th>Latitude</th>
<th>Longitude</th>
<th>DIGIPIN</th>
</tr>
</thead>

<tbody id="tableBody">
<c:forEach var="r" items="${resultList}">
<tr>
<td>${r.uid}</td>
<td><fmt:formatNumber value="${r.lat}" minFractionDigits="6" maxFractionDigits="6"/></td>
<td><fmt:formatNumber value="${r.lon}" minFractionDigits="6" maxFractionDigits="6"/></td>
<td>${r.digipin}</td>
</tr>
</c:forEach>
</tbody>
</table>

<hr>

<input type="text" id="searchBox" class="form-control"
placeholder="Search by UID / DIGIPIN / Latitude,Longitude">

<button class="btn btn-warning mt-2 w-100" onclick="searchMarker()">Search</button>

<div id="mapSection">
    <div id="map" class="mt-3"></div>
</div>

</div>
</div>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster/dist/leaflet.markercluster.js"></script>
<script src="https://unpkg.com/leaflet.fullscreen@1.6.0/Control.FullScreen.js"></script>

<script>

// ⭐ MAP INIT
var map = L.map('map',{
    zoomControl:false,
    fullscreenControl:true,
    fullscreenControlOptions:{
        position:'topright'
    }
}).setView([22.9734,78.6569],5);
L.control.zoom({
    position:'topleft'
}).addTo(map);
map.on('enterFullscreen', function(){
    map.invalidateSize();
});

map.on('exitFullscreen', function(){
    map.invalidateSize();
});

// ⭐ OPEN SOURCE BASEMAPS (FIXED ATTRIBUTIONS)
var osm = L.tileLayer(
 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
 { attribution:'© OpenStreetMap contributors' }
);

var dark = L.tileLayer(
 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
 { attribution:'© CartoDB' }
);

var terrain = L.tileLayer(
 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png',
 { attribution:'© OpenTopoMap' }
);

var esriSat = L.tileLayer(
 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
 { attribution:'© Esri Satellite' }
);

var esriStreets = L.tileLayer(
 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',
 { attribution:'© Esri Streets' }
);
var esriHybrid = L.layerGroup([
    L.tileLayer(
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        { attribution:'© Esri Satellite' }
    ),
    L.tileLayer(
        'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
        { attribution:'© Esri Labels' }
    )
]);
osm.addTo(map);

L.control.layers({
 "🌍 OpenStreetMap": osm,
 "🌃 Dark": dark,
 "🗺 Terrain": terrain,
 "🛰 Satellite": esriSat,
 "🌆 Streets": esriStreets,
 "🧭 Hybrid": esriHybrid
}).addTo(map);
L.control.scale().addTo(map);

// ⭐ DATA
var firstLocations = ${jsonData};
var allLocations = ${jsonAllData};

var clusterGroup = L.markerClusterGroup();
var markerMap = {};
var bounds = L.latLngBounds([]);

var blueIcon = new L.Icon({
 iconUrl:'https://maps.google.com/mapfiles/ms/icons/blue-dot.png',
 iconSize:[32,32],
 iconAnchor:[16,32]
});

function addMarker(r){

 var marker=L.marker([r.lat,r.lon],{icon:blueIcon});

 markerMap[r.digipin.trim().toUpperCase()] = marker;
 markerMap[r.uid.trim().toUpperCase()] = marker;

 marker.bindPopup(
  "<b>UID:</b>"+r.uid+
  "<br><b>DIGIPIN:</b>"+r.digipin+
  "<br><b>Latitude:</b>"+Number(r.lat).toFixed(6)+
"<br><b>Longitude:</b>"+Number(r.lon).toFixed(6)
 );

 clusterGroup.addLayer(marker);
 bounds.extend([r.lat,r.lon]);
}

// ⭐ INITIAL LOAD
firstLocations.forEach(addMarker);
map.addLayer(clusterGroup);

if(bounds.isValid()){
 map.fitBounds(bounds);
}

// ⭐ SHOW ALL
function showAllRecords(){

 var html="";
 allLocations.forEach(function(r){
  html += "<tr><td>"+r.uid+"</td><td>"+Number(r.lat).toFixed(6)+"</td><td>"+Number(r.lon).toFixed(6)+"</td><td>"+r.digipin+"</td></tr>";
 });

 document.getElementById("tableBody").innerHTML=html;

 clusterGroup.clearLayers();
 markerMap={};
 bounds=L.latLngBounds([]);

 allLocations.forEach(addMarker);
 map.fitBounds(bounds);

 document.getElementById("showAllBtn").style.display="none";
 document.getElementById("showLessBtn").style.display="inline-block";
}

// ⭐ SHOW LESS
function showLessRecords(){

 var html="";
 firstLocations.forEach(function(r){
  html += "<tr><td>"+r.uid+"</td><td>"+Number(r.lat).toFixed(6)+"</td><td>"+Number(r.lon).toFixed(6)+"</td><td>"+r.digipin+"</td></tr>";
 });

 document.getElementById("tableBody").innerHTML=html;

 clusterGroup.clearLayers();
 markerMap={};
 bounds=L.latLngBounds([]);

 firstLocations.forEach(addMarker);
 map.fitBounds(bounds);

 document.getElementById("showAllBtn").style.display="inline-block";
 document.getElementById("showLessBtn").style.display="none";
}

// ⭐ SEARCH (FIXED)
function searchMarker(){

 var input=document.getElementById("searchBox").value.trim().toUpperCase();

 if(input.includes(",")){
  var p=input.split(",");
  map.flyTo([parseFloat(p[0]),parseFloat(p[1])],16);
  return;
 }

 if(markerMap[input]){
  var marker=markerMap[input];
  map.flyTo(marker.getLatLng(),16);
  marker.openPopup();
 }else{
  alert("Not found");
 }
}
function scrollToMap(){

    document.getElementById("mapSection").scrollIntoView({
        behavior: "smooth",
        block: "start"
    });

    // Show back to top button
    document.getElementById("backToTopBtn").style.display = "block";
}
function scrollToTop(){

    window.scrollTo({
        top: 0,
        behavior: "smooth"
    });

    // Hide button again
    document.getElementById("backToTopBtn").style.display = "none";
}
function downloadData(){

    let format = document.getElementById("downloadFormat").value;

    window.location.href = "download?format=" + format;
}
</script>
<!-- 🔼 Back To Top Button -->
<!-- 🔼 Fixed Go To Top Button -->
<!-- 🔼 Back To Top Button -->
<!-- 🔼 Circular Back To Top Button -->
<button id="backToTopBtn"
        onclick="scrollToTop()"
        style="
            position: fixed;
            bottom: 25px;
            right: 25px;
            width: 55px;
            height: 55px;
            border-radius: 50%;
            border: none;
            background: #212529;
            color: white;
            font-size: 22px;
            display: none;
            align-items: center;
            justify-content: center;
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
            transition: all 0.3s ease;
            z-index: 9999;
        ">
    ⬆
</button>
</body>
</html>