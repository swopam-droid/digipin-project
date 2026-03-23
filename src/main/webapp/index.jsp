<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>DIGIPIN Converter | Enterprise Geo Address Platform</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

        <style>

            body{
    font-family:'Inter',sans-serif;
    color:white;
    min-height:100vh;

    background:
        linear-gradient(135deg, #0F766E 0%, #065F73 40%, #0B3C5D 100%),
        radial-gradient(circle at 20% 30%, rgba(255,255,255,0.05), transparent 40%);
}


            /* NAVBAR */
            .navbar{
                background:#0B1F2A;
                border-bottom:1px solid rgba(255,255,255,0.08);
            }

            /* HERO SECTION */
            .hero{
                padding:120px 40px;
                text-align:center;
            }

            /* TITLE */
            .hero h1{
                font-size:48px;
                font-weight:800;
                letter-spacing:-0.5px;
                margin-bottom:10px;
                line-height:1.2;
            }

            /* SUBTITLE */
            .hero p{
                font-size:22px;
                color:#E5E7EB;
                margin-top:24px;
                line-height:1.5;
            }

            /* BUTTON */
            .glow-btn{
    padding:12px 34px;
    border-radius:999px;
    font-weight:500;
    font-size:18px;

    background: rgba(255,255,255,0.05);
    border:1.5px solid rgba(255,255,255,0.6);
    color:#FFFFFF;

    transition:all .3s ease;
    position:relative;
    overflow:hidden;

    backdrop-filter: blur(6px);
}

/* shine animation */
.glow-btn::before{
    content:"";
    position:absolute;
    top:0;
    left:-120%;
    width:100%;
    height:100%;
    background:linear-gradient(
        120deg,
        transparent,
        rgba(255,255,255,0.3),
        transparent
    );
    transition:all .5s ease;
}

.glow-btn:hover::before{
    left:120%;
}

/* hover */
.glow-btn:hover{
    background:#ffffff;
    color:#0D1A24;
    transform:translateY(-2px);
    box-shadow:0 10px 30px rgba(0,0,0,0.35);
}

            /* FEATURE CARDS */
            .feature-card{
    border-radius:20px;
    background: rgba(255,255,255,0.06);
    padding:32px;
    backdrop-filter: blur(14px);

    height:100%;
    display:flex;
    flex-direction:column;
    justify-content:center;

    border:1px solid rgba(255,255,255,0.08);

    transition:all .35s ease;
}
.feature-card h5 {
    transition: color 0.3s ease;
}

.feature-card:hover h5 {
    color: #60A5FA;
}

.feature-card:hover{
    transform:translateY(-8px) scale(1.02);
    border:1px solid rgba(255,255,255,0.2);
    box-shadow:0 20px 50px rgba(0,0,0,0.4);
}
            /* FOOTER */
            .footer{
                margin-top:80px;
                color:#bbb;
            }
            .fade-in{
                animation: fadeIn 1.2s ease;
            }

            @keyframes fadeIn{
                from{
                    opacity:0;
                    transform:translateY(20px);
                }
                to{
                    opacity:1;
                    transform:translateY(0);
                }
            }
            @media (max-width:768px){
    .hero h1{
        font-size:36px;
    }

    .hero p{
        font-size:18px;
    }

    .glow-btn{
        font-size:16px;
        padding:10px 24px;
    }
}
.glow-btn i{
    transition: transform 0.3s ease;
}

.glow-btn:hover i{
    transform: translateX(4px) rotate(-5deg);
}

        </style>

    </head>

    <body>

        <!-- NAVBAR -->
        <nav class="navbar navbar-dark py-3">
            <div class="container">
                <span class="navbar-brand fw-bold fs-4" style="color:#ffffff;">
                    🌐 Geo-Intelligence Enterprise Hub
                </span>
                <a href="${pageContext.request.contextPath}/upload.jsp"
                   class="btn btn-outline-light rounded-pill">
                    Launch Console
                </a>
            </div>
        </nav>

        <!-- HERO SECTION -->
        <section class="hero text-center fade-in">
            <div class="container">

                <h1>
                    Next-Gen Digital Location Intelligence
                </h1>

                <p>
                    Empowering businesses and developers with next-generation geospatial precision.
                </p>

                <div class="mt-5">
                    <a href="${pageContext.request.contextPath}/upload.jsp"
   class="btn btn-primary btn-lg glow-btn">
   <i class="bi bi-rocket-takeoff me-2"></i>
   Start Conversion
</a>
                </div>

            </div>
        </section>

        <section class="container fade-in" style="margin-top:10px;">
            <div class="row g-4 justify-content-center align-items-stretch">

                <div class="col-md-5">
                    <div class="feature-card text-center">
                        <h5>⚡ High-Performance Batch Processing</h5>
                        <p class="mt-3">
                            Upload thousands of records and convert instantly.
                        </p>
                    </div>
                </div>

                <div class="col-md-5">
                    <div class="feature-card text-center">
                        <h5>🗺️ Live GIS Visualization</h5>
                        <p class="mt-3">
                            Interactive maps with clustering and search.
                        </p>
                    </div>
                </div>



            </div>
        </section>
        <!-- FOOTER --> <div class="text-center footer py-4"> <small> Built with Java Servlets • Leaflet GIS • Bootstrap • Render Cloud </small> </div>




    </body>
</html>