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

        // ⭐ try-with-resources = auto close stream (safer)
        try(BufferedReader br = new BufferedReader(
                new InputStreamReader(filePart.getInputStream(), StandardCharsets.UTF_8), 8192
        )) {

            DigipinService service = new DigipinService();

            // ⭐ Pre-sized list for big CSV
            List<Location> list = new ArrayList<>(10000);

            String line;

            br.readLine(); // skip header

            while((line = br.readLine()) != null){

                if(line.trim().isEmpty()) continue;

                try{

                    String[] data = line.split(",");

                    if("encode".equals(mode)){

                        double lat = Double.parseDouble(data[0].trim());
                        double lon = Double.parseDouble(data[1].trim());

                        String digipin = service.encode(lat,lon);

                        list.add(new Location(lat,lon,digipin));

                    }else{

                        String dp = data[0].trim();

                        double[] coord = service.decode(dp);

                        list.add(new Location(coord[0],coord[1],dp));
                    }

                }catch(Exception e){
                    System.out.println("Invalid row skipped: "+line);
                }
            }

            // ⭐ Show only 500 rows in table UI
            List<Location> displayList =
                    list.size()>500 ? list.subList(0,500) : list;

            req.setAttribute("resultList",displayList);
            req.getSession().setAttribute("resultList",list);
            req.setAttribute("mode",mode);

            // ⭐ Ultra-fast JSON data for map
            String jsonData = convertToJson(displayList);
            req.setAttribute("jsonData",jsonData);

            req.getRequestDispatcher("result.jsp").forward(req,res);
        }
    }

    // ⭐ JSON CONVERTER (SAFE VERSION)
    private String convertToJson(List<Location> list){

        StringBuilder json = new StringBuilder("[");
        for(int i=0;i<list.size();i++){

            Location l = list.get(i);

            json.append("{")
                    .append("\"lat\":").append(l.getLat()).append(",")
                    .append("\"lon\":").append(l.getLon()).append(",")
                    .append("\"digipin\":\"").append(escapeJson(l.getDigipin())).append("\"")
                    .append("}");

            if(i<list.size()-1) json.append(",");
        }
        json.append("]");
        return json.toString();
    }

    // ⭐ Prevent JSON breaking if special chars appear
    private String escapeJson(String text){
        if(text == null) return "";
        return text.replace("\"","\\\"");
    }
}