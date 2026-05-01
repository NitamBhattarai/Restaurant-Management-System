<%-- views/shared/header.jsp — included in every page --%> <%@ taglib prefix="c"
uri="http://xmlns.jcp.org/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title><c:out value="${pageTitle}"/> — Gokyo Bistro</title>
    <!-- Tailwind CSS via CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Google Fonts: Playfair Display + Jost -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,700;1,400;1,500&family=Jost:wght@300;400;500;600&display=swap"
      rel="stylesheet"
    />
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              forest: {
                DEFAULT: "#1a3a2e",
                md: "#234d3c",
                lt: "#2d6147",
                dim: "rgba(26,58,46,0.07)",
                dim2: "rgba(26,58,46,0.14)",
              },
              paper: "#f5f3ef",
              paper2: "#efede9",
              paper3: "#e8e5df",
              ink: "#1a1a18",
              ink2: "#2e2d2b",
              muted: "#7a7870",
              muted2: "#a8a49c",
              gold: "#c4973a",
            },
            fontFamily: {
              serif: ['"Playfair Display"', "Georgia", "serif"],
              sans: ["Jost", "sans-serif"],
            },
          },
        },
      };
    </script>
    <style>
      body {
        font-family: "Jost", sans-serif;
        background-color: #f5f3ef;
        color: #1a1a18;
      }
      .font-serif {
        font-family: "Playfair Display", Georgia, serif;
      }
      /* Shared badge tokens */
      .badge-pending {
        background: #fdf3dc;
        color: #8a6010;
      }
      .badge-preparing {
        background: #fde8de;
        color: #8a3a1a;
      }
      .badge-ready {
        background: #dff0e8;
        color: #1a5c38;
      }
      .badge-served {
        background: #e0eaf5;
        color: #1a3a6a;
      }
      .badge-paid {
        background: rgba(26, 58, 46, 0.1);
        color: #2d6147;
      }
      .badge-unpaid {
        background: rgba(192, 57, 43, 0.08);
        color: #8a1a1a;
      }
      .badge-cancelled {
        background: #f0f0f0;
        color: #7a7870;
      }
      .badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        padding: 3px 10px;
        border-radius: 9999px;
        font-size: 11px;
        font-weight: 500;
      }
      /* Sidebar active link */
      .sb-active {
        color: #1a3a2e !important;
        background: rgba(26, 58, 46, 0.07) !important;
        border-left-color: #1a3a2e !important;
        font-weight: 500 !important;
      }
      /* Form field focus */
      .gk-field:focus {
        outline: none;
        border-color: #1a3a2e !important;
      }
      /* Animation */
      @keyframes fadeUp {
        from {
          opacity: 0;
          transform: translateY(16px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }
      .fade-up {
        animation: fadeUp 0.5s ease both;
      }
    </style>
  </head>
  <body class="antialiased"></body>
</html>
