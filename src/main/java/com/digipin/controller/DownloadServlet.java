package com.digipin.controller;

import com.digipin.model.Location;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req,HttpServletResponse res)
            throws ServletException,IOException{

        List<Location> list =
                (List<Location>) req.getSession().getAttribute("resultList");

        res.setContentType("text/csv");
        res.setHeader("Content-Disposition","attachment; filename=result.csv");

        PrintWriter writer=res.getWriter();

        writer.println("uid,Latitude,Longitude,DIGIPIN");

        for(Location l:list){

            writer.println(
                l.getUid()+","+
                l.getLat()+","+
                l.getLon()+","+
                l.getDigipin()
            );
        }
    }
}