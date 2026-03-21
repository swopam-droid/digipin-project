package com.digipin.controller;

import com.digipin.model.Location;
import com.digipin.service.DigipinService;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import java.io.*;
import java.util.*;

@WebServlet("/upload")
@MultipartConfig
public class UploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");

        Part filePart = req.getPart("file");

        BufferedReader br = new BufferedReader(
                new InputStreamReader(filePart.getInputStream()),8192
        );

        DigipinService service = new DigipinService();

        List<Location> list = new ArrayList<>();

        String header = br.readLine();

        if(header == null) throw new ServletException("Empty CSV");

        String[] headers = header.split(",");

        Map<String,Integer> map = new HashMap<>();

        for(int i=0;i<headers.length;i++){
            map.put(headers[i].trim().toLowerCase(),i);
        }
        if("encode".equals(mode)){
    if(!map.containsKey("latitude") || !map.containsKey("longitude")){
        throw new ServletException("CSV must contain Latitude and Longitude columns");
    }
}else{
    if(!map.containsKey("digipin")){
        throw new ServletException("CSV must contain DIGIPIN column");
    }
}

        String line;

        while((line = br.readLine()) != null){

            if(line.trim().isEmpty()) continue;

            try{

                String[] data = line.split(",", -1);

                String uid = map.containsKey("uid")
                        ? data[map.get("uid")].trim()
                        : "";

                if("encode".equals(mode)){

                    double lat = Double.parseDouble(data[map.get("latitude")]);
                    double lon = Double.parseDouble(data[map.get("longitude")]);

                    String digipin = service.encode(lat,lon);

                    list.add(new Location(uid,lat,lon,digipin));

                }else{

                    String dp = data[map.get("digipin")].trim();

                    double[] coord = service.decode(dp);

                    list.add(new Location(uid,coord[0],coord[1],dp));
                }

            }catch(Exception e){
                System.out.println("Invalid row skipped: "+line);
            }
        }

        req.getSession().setAttribute("resultList",list);

        List<Location> first10 =
                list.size()>10 ? list.subList(0,10) : list;

        req.setAttribute("resultList",first10);
        req.setAttribute("mode",mode);

        req.setAttribute("jsonData",convertToJson(first10));
        req.setAttribute("jsonAllData",convertToJson(list));
        br.close();
        req.getRequestDispatcher("result.jsp").forward(req,res);
    }

    private String convertToJson(List<Location> list){

    StringBuilder json = new StringBuilder("[");

    for(int i=0;i<list.size();i++){

        Location l = list.get(i);

        json.append("{")
            .append("\"uid\":\"").append(safe(l.getUid())).append("\",")
            .append("\"lat\":").append(l.getLat()).append(",")
            .append("\"lon\":").append(l.getLon()).append(",")
            .append("\"digipin\":\"").append(safe(l.getDigipin())).append("\"")
            .append("}");

        if(i<list.size()-1) json.append(",");
    }

    json.append("]");

    return json.toString();
}
    private String safe(String s){
    return s == null ? "" : s.replace("\"","\\\"");
}
}