<%-- views/shared/header.jsp — included in every page --%> <%@ taglib prefix="c"
uri="jakarta.tags.core" %>
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
      href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500&family=Inter:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <script>
      tailwind.config = {
        theme: {
          extend: {
            colors: {
              forest: {
                DEFAULT: "#114b3e",
                md: "#0e3b31",
                lt: "#186654",
                dim: "rgba(17,75,62,0.07)",
                dim2: "rgba(17,75,62,0.14)",
              },
              paper: "#fbfbfb",
              paper2: "#f6f8f7",
              paper3: "#eef0f0",
              ink: "#111827",
              ink2: "#374151",
              muted: "#6b7280",
              muted2: "#9ca3af",
              gold: "#f5a623",
            },
            fontFamily: {
              serif: ['"Playfair Display"', "Georgia", "serif"],
              sans: ["Inter", "sans-serif"],
            },
          },
        },
      };
    </script>
    <style>
      body {
        font-family: "Inter", sans-serif;
        background-color: #fbfbfb;
        color: #111827;
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
        color: #114b3e !important;
        background: #eef8f4 !important;
        border-left-color: #114b3e !important;
        font-weight: 500 !important;
      }
      /* Form field focus */
      .gk-field:focus {
        outline: none;
        border-color: #114b3e !important;
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
  <body class="antialiased">
