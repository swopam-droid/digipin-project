/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.digipin.controller;

import com.digipin.model.Location;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import java.io.*;
import java.util.*;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Get result list stored in session
        List<Location> list = (List<Location>) req.getSession().getAttribute("resultList");

        // Set response type
        res.setContentType("text/csv");
        res.setHeader("Content-Disposition", "attachment; filename=digipin_result.csv");

        PrintWriter out = res.getWriter();

        // CSV Header
        out.println("lat,lon,digipin");

        if (list != null) {
            for (Location loc : list) {
                out.println(loc.getLat() + "," + loc.getLon() + "," + loc.getDigipin());
            }
        }

        out.flush();
        out.close();
    }
}
