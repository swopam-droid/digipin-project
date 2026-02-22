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
#map{height:420px;}
</style>
</head>

<body class="bg-light">

<div class="container mt-5">
<div class="card shadow p-4">

<h3 class="mb-4">Conversion Result</h3>

<c:if test="${not empty resultList}">
<p class="text-muted">
Showing first 500 records for performance.
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

<tbody>
<c:forEach var="r" items="${resultList}">
<tr>
<td>${r.uid}</td>
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

<!-- ⭐ UNIVERSAL SEARCH -->
<div class="mb-3">
<input type="text" id="searchInput" class="form-control"
placeholder="Search UID / DIGIPIN / Latitude,Longitude (e.g 22.57,88.36)">
<button class="btn btn-warning mt-2" onclick="searchMarker()">Search</button>
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

// ⭐ MAP INIT
var map=L.map('map',{zoomControl:true})
.setView([22.9734,78.6569],5);

/////////////////////////
// ⭐ MULTIPLE BASEMAPS
/////////////////////////

var osm=L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');

var cartoLight=L.tileLayer(
'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png');

var cartoDark=L.tileLayer(
'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png');

var esriSat=L.tileLayer(
'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}');

var topo=L.tileLayer(
'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png');

osm.addTo(map);

var baseMaps={
 "OpenStreetMap":osm,
 "Carto Light":cartoLight,
 "Carto Dark":cartoDark,
 "ESRI Satellite":esriSat,
 "OpenTopoMap":topo
};

L.control.layers(baseMaps).addTo(map);

/////////////////////////
// ⭐ CLUSTER GROUP
/////////////////////////

var clusterGroup=L.markerClusterGroup();
var markerMap={};
var bounds=L.latLngBounds([]);

// ⭐ FAST JSON FROM SERVLET
var locations=${jsonData};

locations.forEach(function(r){

 var marker=L.marker([r.lat,r.lon]);

 // store by uid + digipin
 markerMap[r.uid]=marker;
 markerMap[r.digipin]=marker;

 marker.bindPopup(
 "<b>UID:</b>"+r.uid+
 "<br><b>DIGIPIN:</b>"+r.digipin+
 "<br><b>Latitude:</b>"+r.lat+
 "<br><b>Longitude:</b>"+r.lon
 );

 clusterGroup.addLayer(marker);
 bounds.extend([r.lat,r.lon]);
});

map.addLayer(clusterGroup);

if(bounds.isValid()){
 map.fitBounds(bounds);
}

/////////////////////////
// ⭐ SMART SEARCH SYSTEM
/////////////////////////

function searchMarker(){

 var val=document.getElementById("searchInput").value.trim();

 // 🔎 CASE 1 — UID or DIGIPIN
 if(markerMap[val]){
   var marker=markerMap[val];
   map.flyTo(marker.getLatLng(),16,{duration:1.5});
   marker.openPopup();
   return;
 }

 // 🔎 CASE 2 — LAT,LON search
 if(val.includes(",")){

   var parts=val.split(",");

   var lat=parseFloat(parts[0]);
   var lon=parseFloat(parts[1]);

   if(!isNaN(lat)&&!isNaN(lon)){
     map.flyTo([lat,lon],16,{duration:1.5});
     L.popup()
      .setLatLng([lat,lon])
      .setContent("Latitude:"+lat+"<br>Longitude:"+lon)
      .openOn(map);
     return;
   }
 }

 alert("UID / DIGIPIN / Latitude,Longitude not found");
}

</script>
</c:if>

</body>
</html>