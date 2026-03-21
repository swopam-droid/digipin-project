package com.digipin.controller;

import com.digipin.model.Location;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import org.geotools.data.*;
import org.geotools.data.shapefile.*;
import org.geotools.data.simple.*;
import org.geotools.feature.simple.*;
import org.geotools.geopkg.GeoPackage;
import org.geotools.referencing.crs.DefaultGeographicCRS;

import org.locationtech.jts.geom.*;
import org.opengis.feature.simple.SimpleFeature;
import org.opengis.feature.simple.SimpleFeatureType;

import java.nio.file.Files;
import java.util.zip.ZipOutputStream;
import java.util.zip.ZipEntry;
import org.geotools.data.collection.ListFeatureCollection;
import org.geotools.feature.SchemaException;
import org.geotools.geopkg.FeatureEntry;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {
    

    protected void doGet(HttpServletRequest req,HttpServletResponse res)
            throws ServletException,IOException{
        res.setCharacterEncoding("UTF-8");
        String format = req.getParameter("format");
if(format == null) format = "csv";

        List<Location> list =
    (List<Location>) req.getSession().getAttribute("resultList");

if(list == null || list.isEmpty()){
    res.getWriter().write("No data available for download");
    return;
}

        switch(format){

    case "geojson":
        exportGeoJSON(list,res);
        break;

    case "kml":
        exportKML(list,res);
        break;

    case "kmz":
        exportKMZ(list,res);
        break;

    case "shp":
    try {
        exportShapefile(list, res);
    } catch (Exception e) {
        res.setContentType("text/plain");
        res.getWriter().write("Shapefile export failed: " + e.getMessage());
    }
    break;


case "gpkg":
    try {
        exportGeoPackage(list, res);
    } catch (Exception e) {
        res.setContentType("text/plain");
        res.getWriter().write("GeoPackage export failed: " + e.getMessage());
    }
    break;


    default:
        exportCSV(list,res);
}
    }
    private void exportCSV(List<Location> list,HttpServletResponse res) throws IOException{

    res.setContentType("text/csv");
    res.setHeader("Content-Disposition","attachment; filename=result.csv");

    PrintWriter writer=res.getWriter();

    writer.println("uid,Latitude,Longitude,DIGIPIN");

    for(Location l:list){
        writer.println(
    "\"" + l.getUid() + "\"," +
    l.getLat() + "," +
    l.getLon() + "," +
    "\"" + l.getDigipin() + "\""
);
    }
    writer.flush();
writer.close();
}
    private void exportGeoJSON(List<Location> list,HttpServletResponse res) throws IOException{

    res.setContentType("application/json");
    res.setHeader("Content-Disposition","attachment; filename=result.geojson");

    StringBuilder geo=new StringBuilder();
    geo.append("{\"type\":\"FeatureCollection\",\"crs\":{\"type\":\"name\",\"properties\":{\"name\":\"EPSG:4326\"}},\"features\":[");
    for(int i=0;i<list.size();i++){
        Location l=list.get(i);

        geo.append("{\"type\":\"Feature\",\"geometry\":{\"type\":\"Point\",\"coordinates\":[")
           .append(l.getLon()).append(",").append(l.getLat())
           .append("]},\"properties\":{\"uid\":\"")
           .append(l.getUid()).append("\",\"digipin\":\"")
           .append(l.getDigipin()).append("\"}}");

        if(i<list.size()-1) geo.append(",");
    }

    geo.append("]}");

    res.getWriter().write(geo.toString());
}
    private void exportKML(List<Location> list,HttpServletResponse res) throws IOException{

    res.setContentType("application/vnd.google-earth.kml+xml");
    res.setHeader("Content-Disposition","attachment; filename=result.kml");

    StringBuilder kml=new StringBuilder();
    kml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    kml.append("<kml><Document>");

    for(Location l:list){
        kml.append("<Placemark>")
           .append("<name>").append(l.getUid()).append("</name>")
           .append("<description>").append(l.getDigipin()).append("</description>")
           .append("<Point><coordinates>")
           .append(l.getLon()).append(",").append(l.getLat())
           .append("</coordinates></Point>")
           .append("</Placemark>");
    }

    kml.append("</Document></kml>");

    res.getWriter().write(kml.toString());
}
    private void exportKMZ(List<Location> list,HttpServletResponse res) throws IOException{

    res.setContentType("application/vnd.google-earth.kmz");
    res.setHeader("Content-Disposition","attachment; filename=result.kmz");

    java.util.zip.ZipOutputStream zos =
        new java.util.zip.ZipOutputStream(res.getOutputStream());

    zos.putNextEntry(new java.util.zip.ZipEntry("doc.kml"));

    StringBuilder kml=new StringBuilder();
    kml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    kml.append("<kml><Document>");

    for(Location l:list){
        kml.append("<Placemark><name>")
           .append(l.getUid())
           .append("</name><Point><coordinates>")
           .append(l.getLon()).append(",").append(l.getLat())
           .append("</coordinates></Point></Placemark>");
    }

    kml.append("</Document></kml>");

    zos.write(kml.toString().getBytes("UTF-8"));

    zos.closeEntry();
    zos.close();
}
    private void exportShapefile(List<Location> list, HttpServletResponse res) throws IOException, SchemaException {

    File tempDir = Files.createTempDirectory("shp").toFile();

    File shpFile = new File(tempDir, "result.shp");

    Map<String, Object> params = new HashMap<>();
    params.put("url", shpFile.toURI().toURL());
    params.put("create spatial index", true);

    ShapefileDataStoreFactory factory = new ShapefileDataStoreFactory();
    ShapefileDataStore dataStore = (ShapefileDataStore) factory.createNewDataStore(params);

    dataStore.setCharset(java.nio.charset.StandardCharsets.UTF_8);

    String typeSpec = "the_geom:Point:srid=4326,uid:String,digipin:String";
    SimpleFeatureType TYPE = DataUtilities.createType("Location", typeSpec);

    dataStore.createSchema(TYPE);

    GeometryFactory geometryFactory = new GeometryFactory();

    DefaultTransaction transaction = new DefaultTransaction("create");

    String typeName = dataStore.getTypeNames()[0];
    SimpleFeatureSource featureSource = dataStore.getFeatureSource(typeName);

    if (featureSource instanceof SimpleFeatureStore) {

        SimpleFeatureStore store = (SimpleFeatureStore) featureSource;

        List<SimpleFeature> features = new ArrayList<>();

        SimpleFeatureBuilder builder = new SimpleFeatureBuilder(TYPE);

        for (Location l : list) {

            Point point = geometryFactory.createPoint(
                    new Coordinate(l.getLon(), l.getLat())
            );

            builder.add(point);
            builder.add(l.getUid());
            builder.add(l.getDigipin());

            features.add(builder.buildFeature(null));
        }

        SimpleFeatureCollection collection = new ListFeatureCollection(TYPE, features);

        store.setTransaction(transaction);
        store.addFeatures(collection);

        transaction.commit();
        transaction.close();
    }

    // ZIP all shapefile parts
    res.setContentType("application/zip");
    res.setHeader("Content-Disposition", "attachment; filename=result_shapefile.zip");

    ZipOutputStream zos = new ZipOutputStream(res.getOutputStream());

    for (File file : tempDir.listFiles()) {
        zos.putNextEntry(new ZipEntry(file.getName()));
        Files.copy(file.toPath(), zos);
        zos.closeEntry();
    }
    for(File f : tempDir.listFiles()){
    f.delete();
}
tempDir.delete();
    zos.close();
}

private void exportGeoPackage(List<Location> list, HttpServletResponse res) throws IOException, SchemaException {

    File gpkgFile = File.createTempFile("result", ".gpkg");

    GeoPackage geopkg = new GeoPackage(gpkgFile);
    geopkg.init();

    String typeSpec = "the_geom:Point:srid=4326,uid:String,digipin:String";
    SimpleFeatureType TYPE = DataUtilities.createType("Location", typeSpec);

    GeometryFactory geometryFactory = new GeometryFactory();
    SimpleFeatureBuilder builder = new SimpleFeatureBuilder(TYPE);

    List<SimpleFeature> features = new ArrayList<>();

    for (Location l : list) {

        Point point = geometryFactory.createPoint(
                new Coordinate(l.getLon(), l.getLat())
        );

        builder.add(point);
        builder.add(l.getUid());
        builder.add(l.getDigipin());

        features.add(builder.buildFeature(null));
    }

    SimpleFeatureCollection collection = new ListFeatureCollection(TYPE, features);

    FeatureEntry entry = new FeatureEntry();
entry.setTableName("locations");
entry.setSrid(4326);

geopkg.add(entry, collection);
    geopkg.close();

    res.setContentType("application/octet-stream");
    res.setHeader("Content-Disposition", "attachment; filename=result.gpkg");

    OutputStream out = res.getOutputStream();
Files.copy(gpkgFile.toPath(), out);
out.flush();
gpkgFile.delete();
}
}
