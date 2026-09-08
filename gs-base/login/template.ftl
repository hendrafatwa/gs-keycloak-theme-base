<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false title="Login">
  <#-- ── Nilai brand per-theme, semuanya bisa ditimpa dari theme.properties ── -->
  <#assign appName        = properties.gsAppName!'GS Portal'>
  <#assign companyName    = properties.gsCompanyName!'PT. GS BATTERY'>
  <#assign appVersion     = properties.gsAppVersion!'v1.0'>
  <#assign primary        = properties.gsPrimaryColor!'#ED3237'>
  <#assign primaryHover   = properties.gsPrimaryHoverColor!primary>
  <#assign primaryActive  = properties.gsPrimaryActiveColor!primary>
  <#assign primaryRgb     = properties.gsPrimaryColorRgb!'237, 50, 55'>
  <#assign coverBg        = properties.gsCoverBgColor!primary>
  <#assign faviconImg     = properties.gsFavicon!'img/gs/logo_gs_battery_nonbg.png'>
  <#assign brandIcon      = properties.gsBrandIcon!'img/gs/key.png'>
  <#assign slideImg1      = properties.gsSlide1!'img/gs/GSSMART2.png'>
  <#assign slideImg2      = properties.gsSlide2!'img/gs/bg2.png'>
  <#assign pageTitleText  = title + " | " + appName>

<!doctype html>
<html lang="en"
      class="light-style layout-wide customizer-hide"
      dir="ltr"
      data-theme="theme-default"
      data-assets-path="${url.resourcesPath}/assets/"
      data-template="vertical-menu-template"
      data-style="light">
<head>
    <meta charset="utf-8" />
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />

    <title>${pageTitleText}</title>

    <meta name="description" content="" />

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="${url.resourcesPath}/assets/${faviconImg}" />

    <!-- Icons -->
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/fonts/fontawesome.css" />
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/fonts/tabler-icons.css" />
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/fonts/flag-icons.css" />

    <!-- Core CSS -->
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/css/rtl/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/css/rtl/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="${url.resourcesPath}/assets/css/demo.css" />

    <!-- Vendors CSS -->
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/libs/node-waves/node-waves.css" />
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/libs/typeahead-js/typeahead.css" />
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/libs/form-validation/form-validation.css" />

    <!-- Page CSS -->
    <link rel="stylesheet" href="${url.resourcesPath}/assets/vendor/css/pages/page-auth.css" />

    <!-- Helpers -->
    <script src="${url.resourcesPath}/assets/vendor/js/helpers.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/js/template-customizer.js"></script>
    <script src="${url.resourcesPath}/assets/js/config.js"></script>

    <style>
      /* ── Warna brand, di-inject dari theme.properties ── */
      :root {
        --gs-primary:        ${primary};
        --gs-primary-hover:  ${primaryHover};
        --gs-primary-active: ${primaryActive};
        --gs-primary-rgb:    ${primaryRgb};
        --gs-cover-bg:       ${coverBg};
      }

      /* 1) Load Inter dari folder fonts kamu */
      @font-face {
        font-family: 'Inter';
        src: url('${url.resourcesPath}/assets/fonts/inter/static/Inter_24pt-Regular.ttf') format('truetype');
        font-weight: 400;
        font-style: normal;
      }

      @font-face {
        font-family: 'Inter';
        src: url('${url.resourcesPath}/assets/fonts/inter/static/Inter_24pt-Medium.ttf') format('truetype');
        font-weight: 500;
        font-style: normal;
      }

      @font-face {
        font-family: 'Inter';
        src: url('${url.resourcesPath}/assets/fonts/inter/static/Inter_24pt-SemiBold.ttf') format('truetype');
        font-weight: 600;
        font-style: normal;
      }

      @font-face {
        font-family: 'Inter';
        src: url('${url.resourcesPath}/assets/fonts/inter/static/Inter_24pt-Bold.ttf') format('truetype');
        font-weight: 700;
        font-style: normal;
      }

      @font-face {
        font-family: 'Inter';
        src: url('${url.resourcesPath}/assets/fonts/inter/Inter-VariableFont_opsz%2Cwght.ttf') format('truetype');
        font-weight: 100 900;
        font-style: normal;
      }

      /* ── Radio Card Style ────────────────────── */
      .radio-card {
        cursor: pointer;
        margin: 0;
      }

      .radio-card input[type="radio"] {
        display: none;
      }

      .radio-card-body {
        display: flex;
        align-items: center;
        gap: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        padding: 10px 16px;
        transition: all 0.15s ease;
        font-size: 0.9rem;
        /* background: #fff; */
        height: 68px;
      }

      .radio-dot {
        width: 18px;
        height: 18px;
        min-width: 18px;
        border-radius: 50%;
        border: 2px solid #ccc;
        position: relative;
        transition: all 0.15s ease;
      }

      .radio-card input[type="radio"]:checked + .radio-card-body {
        border-color: var(--gs-primary);
      }

      /* lingkaran luar merah solid */
      .radio-card input[type="radio"]:checked + .radio-card-body .radio-dot {
        border-color: var(--gs-primary);
        background-color: var(--gs-primary);
      }

      /* Titik tengah putih */
      .radio-card input[type="radio"]:checked + .radio-card-body .radio-dot::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: #fff;
      }

      /* 2) Timpa semua font jadi Inter */
      html, body,
      .authentication-wrapper,
      .app-brand,
      .form-control,
      .btn,
      input, button, select, textarea {
        font-family: "Inter", sans-serif !important;
      }

      .btn-primary {
        background-color: var(--gs-primary) !important;
        border-color: var(--gs-primary) !important;
      }

      .btn-primary:hover,
      .btn-primary:focus {
        background-color: var(--gs-primary-hover) !important;
        border-color: var(--gs-primary-hover) !important;
      }

      .btn-primary:active,
      .btn-primary.active,
      .show > .btn-primary.dropdown-toggle {
        background-color: var(--gs-primary-active) !important;
        border-color: var(--gs-primary-active) !important;
      }

      .btn-primary:focus-visible {
        box-shadow: 0 0 0 .25rem rgba(var(--gs-primary-rgb), .35) !important;
      }

      a { color: var(--gs-primary); }

      .auth-right-panel {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
      }
      .auth-right-content { flex: 1 1 auto; }

      .auth-footer {
        margin-top: auto;
        padding-top: 0;
        padding-bottom: 0;
      }

      .auth-footer-inner {
        max-width: 100%;
        margin: 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
      }

      .auth-footer-version { color: var(--gs-primary); }

      /* LEFT PANEL IMAGE */
     .left-illustration {
        height: 100%;
        width: 100%;
         max-height: calc(100vh - 2.5rem);
        overflow: hidden;
      }

      .left-image {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }

      .auth-cover-bg {
        height: 100%;
        /* background-color: #f8f9fa; */
        max-height: calc(100vh - 2.5rem);
		    background-color: var(--gs-cover-bg);
      }
	  
      /* Carousel full height - FIXED */
      #authCarousel {
        height: 100%;
        width: 100%;
        position: relative;
      }

      #authCarousel .carousel-inner {
        height: 100%;
        width: 100%;
      }

      #authCarousel .carousel-item {
        height: 100%;
        width: 100%;
        position: relative; /* penting untuk transisi */
      }

      #authCarousel .carousel-item img {
        width: 100%;
        height: 100%;
        object-fit: contain;
        display: block;
      }

      /* Indicator dots styling */
      #authCarousel .carousel-indicators {
        margin-bottom: 1.5rem;
      }

      #authCarousel .carousel-indicators [data-bs-target] {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.5);
        border: none;
        margin: 0 4px;
      }

      #authCarousel .carousel-indicators .active {
        background-color: #ffffff;
      }
      
      #togglePassword i {
        pointer-events: none;
      }

      .form-control {
        border-color: #ccc !important;
      }

      .form-control:focus {
        border-color: var(--gs-primary) !important;
        box-shadow: none !important;
      }

      .input-group .form-control,
      .input-group .input-group-text {
        border-color: #ccc !important;
      }

      .input-group:focus-within .form-control,
      .input-group:focus-within .input-group-text {
        border-color: var(--gs-primary) !important;
        box-shadow: none !important;
      }

      input {
          height: 50px;
      }

      /* BOXS OTP */
     .otp-wrapper {
        display: flex;
        gap: 10px;
        width: 100%;
      }

      .otp-wrapper .otp-input {
        flex: 1 1 0;
        min-width: 0;
        height: 56px;
        padding: 0;
        text-align: center;
        font-size: 1.25rem;
        font-weight: 600;
      }

      /* Extra small - HP kecil (<360px) */
      @media (max-width: 359.98px) {
        .otp-wrapper {
          gap: 6px;
        }
        .otp-wrapper .otp-input {
          height: 48px;
          font-size: 1.1rem;
        }
      }

      /* Small - HP normal (360px - 575px) */
      @media (min-width: 360px) and (max-width: 575.98px) {
        .otp-wrapper {
          gap: 8px;
        }
        .otp-wrapper .otp-input {
          height: 52px;
          font-size: 1.2rem;
        }
      }

      /* Medium - Tablet portrait (576px - 767px) */
      @media (min-width: 576px) and (max-width: 767.98px) {
        .otp-wrapper .otp-input {
          height: 60px;
          font-size: 1.35rem;
        }
      }

      /* Large - Tablet landscape / small desktop (768px - 991px) */
      @media (min-width: 768px) and (max-width: 991.98px) {
        .otp-wrapper .otp-input {
          height: 68px;
          font-size: 1.4rem;
        }
      }

      /* XL - Desktop (992px - 1399px), di sini right panel col-lg-5 aktif */
      @media (min-width: 992px) and (max-width: 1399.98px) {
        .otp-wrapper .otp-input {
          height: 72px;
          font-size: 1.5rem;
        }
      }

       @media (min-width: 1400px) {
        .authentication-cover .authentication-bg.p-sm-12 {
          padding: 2.5rem !important;
        }
        .authentication-cover .authentication-bg.p-6 {
          padding: 2rem !important;
        }
        .authentication-cover .w-px-400 {
          width: 460px !important;
        }

        .otp-wrapper .otp-input {
          height: 80px;
          font-size: 1.6rem;
        }
      }
    </style>
</head>

<body>
    <!-- Content -->
    <div class="authentication-wrapper authentication-cover" style="background-color: #fff; height: 100vh; overflow: hidden;">
        <!-- Logo -->
       <!-- <a href="#" class="app-brand auth-cover-brand">
            <span>
                <img src="${url.resourcesPath}/assets/img/gs/GS-Hitam.png" alt="Logo" style="height: 32px; width: 156px;">
            </span>
        </a> -->
        <!-- /Logo -->

        <div class="authentication-inner row m-0" style="height: 100vh; overflow: hidden;">
            <!-- Left Illustration -->
            <div class="d-none d-lg-flex col-lg-7 p-5 pb-5">
                <div class="auth-cover-bg d-flex justify-content-center align-items-center left-illustration" style="border-radius: 20px; overflow: hidden;">
                    <div id="authCarousel" class="carousel slide">

						<!-- Slides -->
						<div class="carousel-inner">
							<div class="carousel-item">
								<img src="${url.resourcesPath}/assets/${slideImg1}"
									 alt="Login Illustration 2">
							</div>
							<div class="carousel-item active">
								<img src="${url.resourcesPath}/assets/${slideImg2}"
									 alt="Login Illustration 1">
							</div>
						</div>

						<!-- Indicator Dots -->
						<div class="carousel-indicators">
							<button type="button" data-bs-target="#authCarousel" data-bs-slide-to="0"
									class="active" aria-current="true" aria-label="Slide 1"></button>
							<button type="button" data-bs-target="#authCarousel" data-bs-slide-to="1"
									aria-label="Slide 2"></button>
						</div>
						
						<!-- Tombol Pause/Play -->
						<button id="carouselPauseBtn" 
								type="button"
								style="
									position: absolute;
									bottom: 1.5rem;
									right: 3rem;
									z-index: 10;
									background: rgba(255,255,255,0.2);
									border: none;
									border-radius: 50%;
									width: 32px;
									height: 32px;
									display: flex;
									align-items: center;
									justify-content: center;
									cursor: pointer;
									backdrop-filter: blur(4px);
								">
							<i class="ti ti-player-pause" style="color: #fff; font-size: 14px;"></i>
						</button>

						<!-- Tombol Prev & Next -->
						<button class="carousel-control-prev" type="button"
								data-bs-target="#authCarousel" data-bs-slide="prev">
							<span class="carousel-control-prev-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Previous</span>
						</button>
						<button class="carousel-control-next" type="button"
								data-bs-target="#authCarousel" data-bs-slide="next">
							<span class="carousel-control-next-icon" aria-hidden="true"></span>
							<span class="visually-hidden">Next</span>
						</button>

					</div>
                </div>
            </div>
            <!-- /Left Illustration -->

            <!-- Right Panel -->
            <div class="d-flex col-12 col-lg-5 authentication-bg p-sm-12 p-6 auth-right-panel" style="padding-top: 1rem !important;">
               <div class="d-flex align-items-center gap-2 mt-5 mb-5">
                  <img src="${url.resourcesPath}/assets/${brandIcon}" alt="${appName}" style="width: 15px; height: 15px;">
                  <strong style="font-weight: bold !important; font-size: 18px;">${appName}</strong>
              </div>

                <div class="auth-right-content d-flex align-items-center">
                    <div class="w-px-700 mx-auto">

                        <#-- pesan error/sukses Keycloak -->
                        <#if displayMessage && message?has_content>
                          <#-- map type Keycloak ke Bootstrap -->
                          <#assign bsType = (message.type!'info')>
                          <#if bsType == 'error'>
                            <#assign bsType = 'danger'>
                          </#if>

                          <#-- Cek apakah ada error terkait password policy -->
                          <#assign hasPasswordError = false>
                          <#assign passwordErrors = []>
                          
                          <#if messagesPerField??>
                            <#if messagesPerField.existsError('password')>
                              <#assign hasPasswordError = true>
                            </#if>
                            <#if messagesPerField.existsError('password-confirm')>
                              <#assign hasPasswordError = true>
                            </#if>
                          </#if>

                          <#-- Jika ada error password di halaman update password, gabungkan jadi satu pesan -->
                          <#if (isUpdatePasswordPage!false) && hasPasswordError && (message.type!'') == 'error'>
                            <div class="alert alert-${bsType} mb-4" role="alert">
                              <span class="fw-bold">Error!</span>
                              Password must meet the following requirements:
                              <ul class="mb-0 mt-2" style="padding-left: 1.25rem;">
                                <li>Minimum 8 characters</li>
                                <li>At least 1 uppercase letter (A-Z)</li>
                                <li>At least 1 special character (!@#$%^&*)</li>
                                <li>At least 1 number (0-9)</li>
                                <li>Password and confirmation must match</li>
                              </ul>
                            </div>
                          <#else>
                            <#-- Pesan normal untuk halaman lain -->
                            <div class="alert alert-${bsType} mb-4" role="alert">
                              <span class="d-inline-flex align-items-center justify-content-center rounded-circle me-2
                                <#if message.type == 'success'>bg-success</#if>
                                <#if message.type == 'warning'>bg-warning</#if>
                                <#if message.type == 'error'>bg-danger</#if>
                                <#if message.type == 'info'>bg-info</#if>"
                                style="width: 10px; height: 10px;">
                              </span>

                              <#-- Override khusus setelah klik "Send reset link" (emailSentMessage) -->
                              <#if (message.type!'') == 'success' && (message.summary!'') == msg("emailSentMessage")>
                                We've sent an email to
                                <#if login?? && login.username?? && login.username?has_content>
                                  ${kcSanitize(login.username)?no_esc}’s
                                <#else>
                                  your
                                </#if>
                                registered email. Check your inbox and follow the instructions.
                              <#else>
                                ${kcSanitize(message.summary)?no_esc}
                              </#if>
                            </div>
                          </#if>
                        </#if>

                        <#nested "form">
                    </div>
                </div>

                <!-- Footer -->
                <div class="auth-footer">
                    <div class="auth-footer-inner">
                        <small class="text-muted">Copyright © ${.now?string["yyyy"]} ${companyName}</small>
                        <small class="auth-footer-version">${appVersion}</small>
                    </div>
                </div>
            </div>
            <!-- /Right Panel -->
        </div>
    </div>

    <!-- Core JS -->
    <script src="${url.resourcesPath}/assets/vendor/libs/jquery/jquery.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/libs/popper/popper.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/js/bootstrap.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/libs/node-waves/node-waves.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/libs/hammer/hammer.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/libs/i18n/i18n.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/libs/typeahead-js/typeahead.js"></script>
    <script src="${url.resourcesPath}/assets/vendor/js/menu.js"></script>

    <!-- Vendors JS -->
   <#-- Load FormValidation hanya jika bukan halaman login -->
    <#if title != "Login">
        <script src="${url.resourcesPath}/assets/vendor/libs/form-validation/popular.js"></script>
        <script src="${url.resourcesPath}/assets/vendor/libs/form-validation/bootstrap5.js"></script>
        <script src="${url.resourcesPath}/assets/vendor/libs/form-validation/auto-focus.js"></script>
        <script src="${url.resourcesPath}/assets/js/pages-auth.js"></script>
    </#if>

    <!-- Main JS -->
    <script src="${url.resourcesPath}/assets/js/main.js"></script>
	
	<!-- Carousel Script -->
	<script>
	$(document).ready(function () {
		var isPaused   = false;
		var interval   = null;
		var intervalMs = 3000;

		function nextSlide() {
			$('#authCarousel').carousel('next');
		}

		function startAuto() {
			stopAuto(); // selalu clear dulu sebelum buat baru
			interval = setInterval(nextSlide, intervalMs);
		}

		function stopAuto() {
			if (interval !== null) {
				clearInterval(interval);
				interval = null;
			}
		}

		// Mulai saat halaman load
		startAuto();

		// Tombol Pause/Play
		$('#carouselPauseBtn').on('click', function () {
			var icon = $(this).find('i');
			if (isPaused) {
				startAuto();
				icon.removeClass('ti-player-play').addClass('ti-player-pause');
				isPaused = false;
			} else {
				stopAuto();
				icon.removeClass('ti-player-pause').addClass('ti-player-play');
				isPaused = true;
			}
		});

		// Pause saat hover — pakai parent div bukan #authCarousel
		$('.auth-cover-bg').on('mouseenter', function () {
			if (!isPaused) stopAuto();
		}).on('mouseleave', function () {
			if (!isPaused) startAuto();
		});

		// Reset timer saat klik prev/next
		$('#authCarousel .carousel-control-prev, #authCarousel .carousel-control-next').on('click', function () {
			if (!isPaused) {
				startAuto(); // startAuto sudah include stopAuto di dalamnya
			}
		});
	});
	</script>

    <!-- Page JS -->
    <!-- <script src="${url.resourcesPath}/assets/js/pages-auth.js"></script> -->
</body>
</html>
</#macro>