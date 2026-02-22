/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.digipin.controller;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import java.io.*;

@WebServlet("/samplecsv")
public class SampleCSVServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String type = req.getParameter("type");

        res.setContentType("text/csv");

        if ("decode".equals(type)) {
            res.setHeader("Content-Disposition", "attachment; filename=sample_decode.csv");
        } else {
            res.setHeader("Content-Disposition", "attachment; filename=sample_encode.csv");
        }

        PrintWriter out = res.getWriter();

        // Encode sample
        if ("decode".equals(type)) {

            out.println("digipin");
            out.println("FC9-M7M-7JFK");

        } else {

            out.println("lat,lon");
            out.println("22.5726,88.3639");
            out.println("28.6139,77.2090");
        }

        out.flush();
        out.close();
    }
}
