/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.digipin.service;

import com.digipin.encoder.DigipinEncoder;

public class DigipinService {

public String encode(double lat,double lon){
return DigipinEncoder.encode(lat,lon);
}

public double[] decode(String digipin){
return DigipinEncoder.decode(digipin);
}
}
