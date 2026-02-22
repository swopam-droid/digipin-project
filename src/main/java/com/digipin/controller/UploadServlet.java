package com.digipin.controller;

import com.digipin.model.Location;
import com.digipin.service.DigipinService;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

@WebServlet("/upload")
@MultipartConfig
public class UploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");
        Part filePart = req.getPart("file");

        try(BufferedReader br = new BufferedReader(
                new InputStreamReader(filePart.getInputStream(), StandardCharsets.UTF_8),8192)) {

            DigipinService service = new DigipinService();
            List<Location> list = new ArrayList<>(10000);

            // ⭐ READ HEADER
            String headerLine = br.readLine();
            String[] headers = headerLine.split(",");

            int uidIndex=-1, latIndex=-1, lonIndex=-1;

            for(int i=0;i<headers.length;i++){
                String h=headers[i].trim();
                if(h.equalsIgnoreCase("uid")) uidIndex=i;
                if(h.equalsIgnoreCase("Latitude")) latIndex=i;
                if(h.equalsIgnoreCase("Longitude")) lonIndex=i;
            }

            if(latIndex==-1 || lonIndex==-1){
                throw new ServletException("CSV must contain Latitude and Longitude headers");
            }

            String line;

            while((line=br.readLine())!=null){

                if(line.trim().isEmpty()) continue;

                try{

                    String[] data=line.split(",");

                    String uid="";
                    if(uidIndex!=-1 && uidIndex<data.length){
                        uid=data[uidIndex].trim();
                    }

                    if("encode".equals(mode)){

                        double lat=Double.parseDouble(data[latIndex].trim());
                        double lon=Double.parseDouble(data[lonIndex].trim());

                        String digipin=service.encode(lat,lon);

                        list.add(new Location(uid,lat,lon,digipin));

                    }else{

                        String dp=data[0].trim();

                        double[] coord=service.decode(dp);

                        list.add(new Location(uid,coord[0],coord[1],dp));
                    }

                }catch(Exception e){
                    System.out.println("Invalid row skipped: "+line);
                }
            }

            List<Location> displayList =
                    list.size()>500 ? list.subList(0,500) : list;

            req.setAttribute("resultList",displayList);
            req.getSession().setAttribute("resultList",list);
            req.setAttribute("mode",mode);
            req.setAttribute("jsonData",convertToJson(displayList));

            req.getRequestDispatcher("result.jsp").forward(req,res);
        }
    }

    private String convertToJson(List<Location> list){

        StringBuilder json=new StringBuilder("[");

        for(int i=0;i<list.size();i++){

            Location l=list.get(i);

            json.append("{")
                .append("\"uid\":\"").append(l.getUid()).append("\",")
                .append("\"lat\":").append(l.getLat()).append(",")
                .append("\"lon\":").append(l.getLon()).append(",")
                .append("\"digipin\":\"").append(l.getDigipin()).append("\"")
                .append("}");

            if(i<list.size()-1) json.append(",");
        }

        json.append("]");
        return json.toString();
    }
}