package com.digipin.controller;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/samplecsv")
public class SampleCSVServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String type = req.getParameter("type");

        // ⭐ SAFETY CHECK
        if(type == null){
            type = "";
        }

        // ⭐ SET FILE NAME BASED ON MODE
        String fileName;

        if("encode".equalsIgnoreCase(type)){
            fileName = "To_Digipin.csv";
        }else{
            fileName = "To_Latitude_Longitude.csv";
        }

        res.setContentType("text/csv");
        res.setHeader("Content-Disposition",
                "attachment; filename=\"" + fileName + "\"");

        PrintWriter out = res.getWriter();

        // ⭐ TO DIGIPIN SAMPLE
        if("encode".equalsIgnoreCase(type)){

            out.println("uid,Latitude,Longitude");
            out.println("U001,22.5726,88.3639");
            out.println("U002,28.6139,77.2090");
            out.println("U003,19.0760,72.8777");

        }
        // ⭐ TO LATITUDE LONGITUDE SAMPLE
        else{

            out.println("uid,digipin");
            out.println("U001,FC9-M7M-7JFK");
            out.println("U002,FJ3-K4P-TM56");
            out.println("U003,FC9-3C9-7JFT");
        }

        out.flush();
        out.close();
    }
}