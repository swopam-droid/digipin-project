/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.digipin.model;

public class Location {

    private double lat;
    private double lon;
    private String digipin;

    public Location(double lat,double lon,String digipin){
        this.lat=lat;
        this.lon=lon;
        this.digipin=digipin;
    }

    public double getLat(){ return lat; }
    public double getLon(){ return lon; }
    public String getDigipin(){ return digipin; }
}
