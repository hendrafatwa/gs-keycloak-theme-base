<#import "template.ftl" as layout>

<#-- Mode vendor: hanya username, tanpa memilih plant. Diatur lewat config
     authenticator per realm. -->
<#assign isVendor = vendorMode!false>

<@layout.registrationLayout title="Lupa Password"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-mood-nervous" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Lupa / Ingin Ganti Password?</h4>
    <p class="mb-6">Tenang saja! Ikuti langkah berikut untuk atur ulang password Anda.</p>

    <form id="npkForm" action="${url.loginAction}" method="post"
          data-vendor-mode="${isVendor?c}">

      <#if !isVendor>
      <div class="mb-6">
        <label class="form-label d-block">Plant</label>
        <div class="d-flex gap-3">
          <label class="radio-card flex-fill" for="plantKarawang">
            <input type="radio" name="plant" id="plantKarawang" value="K" checked />
            <span class="radio-card-body">
              <span class="radio-dot"></span>
              <span>Karawang</span>
            </span>
          </label>

          <label class="radio-card flex-fill" for="plantSemarang">
            <input type="radio" name="plant" id="plantSemarang" value="M" />
            <span class="radio-card-body">
              <span class="radio-dot"></span>
              <span>Semarang</span>
            </span>
          </label>
        </div>
      </div>
      </#if>

      <div class="mb-6">
        <label for="npk" class="form-label">
          <#if isVendor>Username<#else>6-Digit NPK</#if>
        </label>
        <input type="text" class="form-control" id="npk" name="npk"
               placeholder="<#if isVendor>Username<#else>6-Digit NPK</#if>"
               autofocus autocomplete="off" />
      </div>

      <button id="submitBtn" class="btn btn-primary d-grid w-100 mb-6" type="submit">
        <span id="btnText">Selanjutnya</span>
        <span id="btnLoader" style="display:none;">
          <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
          Memeriksa...
        </span>
      </button>
    </form>

    <a href="${url.loginUrl}" class="btn btn-link text-dark small p-0">
      <i class="ti ti-arrow-left me-1"></i>Kembali ke Sign In
    </a>

    <style>
      #submitBtn:disabled {
        background-color: #6c757d !important;
        border-color: #6c757d !important;
        cursor: not-allowed !important;
        opacity: 0.65;
      }
    </style>

    <script>
    (function () {
      const form      = document.getElementById('npkForm');
      const submitBtn = document.getElementById('submitBtn');
      const btnText   = document.getElementById('btnText');
      const btnLoader = document.getElementById('btnLoader');

      form.addEventListener('submit', function () {
        submitBtn.disabled = true;
        btnText.style.display = 'none';
        btnLoader.style.display = 'inline-block';
      });
    })();
    </script>

  </#if>
</@layout.registrationLayout>
