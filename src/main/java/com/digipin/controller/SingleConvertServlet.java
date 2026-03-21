package com.digipin.controller;

import com.digipin.service.DigipinService;

import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/singleconvert")
public class SingleConvertServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String mode = req.getParameter("mode");

        DigipinService service = new DigipinService();

        res.setContentType("text/plain");
        PrintWriter out = res.getWriter();

        try {

            if ("encode".equals(mode)) {

                String latStr = req.getParameter("lat");
                String lonStr = req.getParameter("lon");

                if (latStr == null || lonStr == null) {
                    out.print("Invalid Input");
                    return;
                }

                double lat = Double.parseDouble(latStr);
                double lon = Double.parseDouble(lonStr);

                String digipin = service.encode(lat, lon);

                if ("Out of bound".equals(digipin)) {
                    out.print("Coordinates Out of Bound");
                } else {
                    out.print(digipin);
                }

            } else if ("decode".equals(mode)) {

                String dp = req.getParameter("digipin");

                if (dp == null || dp.trim().isEmpty()) {
                    out.print("Incorrect DIGIPIN");
                    return;
                }

                double[] coord = service.decode(dp);
                

                out.printf("%.6f,%.6f", coord[0], coord[1]);
                

            }
            else if ("decodeFull".equals(mode)) {

    String src = req.getParameter("src");
    String dest = req.getParameter("dest");

    if (src == null || dest == null || src.trim().isEmpty() || dest.trim().isEmpty()) {
    out.print("Invalid Input");
    return;
}

    double[] s = service.decode(src);
    double[] d = service.decode(dest);

    // format: sLat,sLon|dLat,dLon
    out.printf("%.6f,%.6f|%.6f,%.6f", s[0], s[1], d[0], d[1]);
}
            else {
                out.print("Invalid Mode");
            }

        } catch (NumberFormatException e) {
            // Invalid latitude/longitude format
            out.print("Invalid Coordinates");

        } catch (IllegalArgumentException e) {
            // Validation error from decode()
            out.print("Incorrect DIGIPIN");

        } catch (Exception e) {
            out.print("Server Error");
        }

        out.flush();
        out.close();
    }
}