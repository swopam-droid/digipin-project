package com.digipin.model;

public class Location {

    private String uid;
    private double lat;
    private double lon;
    private String digipin;

    public Location(String uid,double lat,double lon,String digipin){
        this.uid = uid;
        this.lat = lat;
        this.lon = lon;
        this.digipin = digipin;
    }

    public String getUid(){ return uid; }
    public double getLat(){ return lat; }
    public double getLon(){ return lon; }
    public String getDigipin(){ return digipin; }
}