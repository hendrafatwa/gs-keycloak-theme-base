<#import "template.ftl" as layout>

<@layout.registrationLayout title="Password Lama"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-asterisk" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Password Lama</h4>
    <p class="mb-6">Masukkan password lama Anda untuk verifikasi.</p>

    <form id="passwordForm" action="${url.loginAction}" method="post">

      <div class="mb-6">
        <label class="form-label" for="passwordLama">Password</label>
        <div class="input-group input-group-merge">
          <input type="password" id="passwordLama" name="passwordLama"
                 class="form-control" autofocus autocomplete="off"
                 placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" />
          <span class="input-group-text cursor-pointer toggle-password">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
      </div>

      <button id="submitBtn" class="btn btn-primary d-grid w-100 mb-6" type="submit">
        <span id="btnText">Selanjutnya</span>
        <span id="btnLoader" style="display:none;">
          <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
          Memverifikasi...
        </span>
      </button>
    </form>

    <form action="${url.loginAction}" method="post">
      <input type="hidden" name="rpAction" value="BACK_SELECT" />
      <button type="submit" class="btn btn-link text-dark small p-0">
        <i class="ti ti-arrow-left me-1"></i>Kembali ke Verifikasi Akun
      </button>
    </form>

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
      const form      = document.getElementById('passwordForm');
      const submitBtn = document.getElementById('submitBtn');
      const btnText   = document.getElementById('btnText');
      const btnLoader = document.getElementById('btnLoader');

      form.addEventListener('submit', function () {
        submitBtn.disabled = true;
        btnText.style.display = 'none';
        btnLoader.style.display = 'inline-block';
      });

      document.querySelectorAll('.toggle-password').forEach(function (el) {
        el.addEventListener('click', function () {
          const input = this.parentElement.querySelector('input');
          const icon  = this.querySelector('i');
          if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('ti-eye-off', 'ti-eye');
          } else {
            input.type = 'password';
            icon.classList.replace('ti-eye', 'ti-eye-off');
          }
        });
      });
    })();
    </script>

  </#if>
</@layout.registrationLayout>
