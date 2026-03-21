/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.digipin.encoder;

public class DigipinEncoder {

static char[][] L = {
{'F','C','9','8'},
{'J','3','2','7'},
{'K','4','5','6'},
{'L','M','P','T'}
};

public static String encode(double lat,double lon){

double MinLat=2.5, MaxLat=38.5;
double MinLon=63.5, MaxLon=99.5;

if(lat<MinLat||lat>MaxLat) return "Out of bound";
if(lon<MinLon||lon>MaxLon) return "Out of bound";

StringBuilder vDIGIPIN=new StringBuilder();

for(int lvl=1; lvl<=10; lvl++){

double LatDivDeg=(MaxLat-MinLat)/4;
double LonDivDeg=(MaxLon-MinLon)/4;

int row=0,col=0;

double NextLvlMaxLat=MaxLat;
double NextLvlMinLat=MaxLat-LatDivDeg;

for(int x=0;x<4;x++){
if(lat>=NextLvlMinLat && lat<NextLvlMaxLat){
row=x; break;
}else{
NextLvlMaxLat=NextLvlMinLat;
NextLvlMinLat=NextLvlMaxLat-LatDivDeg;
}
}

double NextLvlMinLon=MinLon;
double NextLvlMaxLon=MinLon+LonDivDeg;

for(int x=0;x<4;x++){
if(lon>=NextLvlMinLon && lon<NextLvlMaxLon){
col=x; break;
}else{
NextLvlMinLon=NextLvlMaxLon;
NextLvlMaxLon=NextLvlMinLon+LonDivDeg;
}
}

vDIGIPIN.append(L[row][col]);

if(lvl==3||lvl==6) vDIGIPIN.append("-");

MinLat=NextLvlMinLat;
MaxLat=NextLvlMaxLat;
MinLon=NextLvlMinLon;
MaxLon=NextLvlMaxLon;
}

return vDIGIPIN.toString();
}

public static double[] decode(String digipin){

    if(digipin == null || digipin.trim().isEmpty()){
        throw new IllegalArgumentException("Incorrect DIGIPIN");
    }

    digipin = digipin.trim().toUpperCase();

    // Remove hyphens
    digipin = digipin.replace("-","");

    // Expected length = 10 levels
    if(digipin.length() != 10){
        throw new IllegalArgumentException("Incorrect DIGIPIN");
    }

    double minLat=2.5,maxLat=38.5;
    double minLng=63.5,maxLng=99.5;

    for(int i=0;i<digipin.length();i++){

        char ch=digipin.charAt(i);

        int row=-1,col=-1;

        boolean found=false;

        for(int r=0;r<4;r++){
            for(int c=0;c<4;c++){
                if(L[r][c]==ch){
                    row=r;
                    col=c;
                    found=true;
                    break;
                }
            }
            if(found) break;
        }

        // 🚨 IMPORTANT VALIDATION
        if(!found){
            throw new IllegalArgumentException("Incorrect DIGIPIN");
        }

        double latStep=(maxLat-minLat)/4;
        double lngStep=(maxLng-minLng)/4;

        double lat1=maxLat-latStep*(row+1);
        double lat2=maxLat-latStep*row;
        double lng1=minLng+lngStep*col;
        double lng2=minLng+lngStep*(col+1);

        minLat=lat1; 
        maxLat=lat2;
        minLng=lng1; 
        maxLng=lng2;
    }

    double centerLat=(minLat+maxLat)/2;
    double centerLng=(minLng+maxLng)/2;

    // Extra safety validation
    if(centerLat < 2.5 || centerLat > 38.5 ||
       centerLng < 63.5 || centerLng > 99.5){
        throw new IllegalArgumentException("Incorrect DIGIPIN");
    }

    return new double[]{centerLat,centerLng};
}
}