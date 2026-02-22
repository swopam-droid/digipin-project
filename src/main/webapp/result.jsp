<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
<title>Result</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

<link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.css"/>
<link rel="stylesheet" href="https://unpkg.com/leaflet.markercluster/dist/MarkerCluster.Default.css"/>

<style>
#map{height:400px;}
</style>
</head>

<body class="bg-light">

<div class="container mt-5">
<div class="card shadow p-4">

<h3 class="mb-4">Conversion Result</h3>

<c:if test="${not empty resultList}">
<p class="text-muted">
Showing first 500 records for performance. Full data available in CSV download.
</p>

<table class="table table-bordered table-striped">
<thead class="table-dark">
<tr>
<th>Latitude</th>
<th>Longitude</th>
<th>DIGIPIN</th>
</tr>
</thead>

<tbody>
<c:forEach var="r" items="${resultList}">
<tr>
<td>${r.lat}</td>
<td>${r.lon}</td>
<td>${r.digipin}</td>
</tr>
</c:forEach>
</tbody>
</table>
</c:if>

<hr>

<h5>Map Preview</h5>

<div class="mb-3">
<input type="text" id="searchDigipin" class="form-control" placeholder="Enter DIGIPIN to zoom">
<button class="btn btn-warning mt-2" onclick="searchMarker()">Search DIGIPIN</button>
</div>

<div id="map"></div>

<div class="mt-3">
<a href="download" class="btn btn-primary">Download CSV</a>
<a href="upload.jsp" class="btn btn-secondary">Back</a>
</div>

</div>
</div>

<script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
<script src="https://unpkg.com/leaflet.markercluster/dist/leaflet.markercluster.js"></script>

<c:if test="${not empty resultList}">
<script>

var map = L.map('map',{zoomControl:true})
.setView([22.9734,78.6569],5);

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',{
 attribution:'© OpenStreetMap'
}).addTo(map);

var clusterGroup = L.markerClusterGroup();

var markerMap = {};
var bounds = L.latLngBounds([]);

var blueIcon = new L.Icon({
 iconUrl:'https://maps.google.com/mapfiles/ms/icons/blue-dot.png',
 iconSize:[32,32],
 iconAnchor:[16,32]
});

var greenIcon = new L.Icon({
 iconUrl:'https://maps.google.com/mapfiles/ms/icons/green-dot.png',
 iconSize:[32,32],
 iconAnchor:[16,32]
});

// ⭐ ULTRA FAST JSON DATA
var locations = ${jsonData};

locations.forEach(function(r){

 var iconToUse = "${mode}"==="encode"?blueIcon:greenIcon;

 var marker = L.marker([r.lat,r.lon],{icon:iconToUse});

 markerMap[r.digipin] = marker;

 marker.bindPopup(
  "<b>DIGIPIN:</b>"+r.digipin+
  "<br><b>Lat:</b>"+r.lat+
  "<br><b>Lon:</b>"+r.lon
 );

 clusterGroup.addLayer(marker);
 bounds.extend([r.lat,r.lon]);
});

map.addLayer(clusterGroup);

if(bounds.isValid()){
 map.flyToBounds(bounds,{padding:[50,50],duration:1.5});
}

function searchMarker(){

 var dp=document.getElementById("searchDigipin").value.trim();

 if(markerMap[dp]){
   var marker=markerMap[dp];
   map.flyTo(marker.getLatLng(),16,{duration:1.5});
   marker.openPopup();
 }else{
   alert("DIGIPIN not found on map");
 }
}

</script>
</c:if>

</body>
</html>