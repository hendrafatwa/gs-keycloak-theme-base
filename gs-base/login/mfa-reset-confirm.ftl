<#import "template.ftl" as layout>

<@layout.registrationLayout title="Reset Microsoft Authenticator"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
            style="width: 56px; height: 56px;">
        <i class="ti ti-refresh" style="font-size: 28px; color: var(--gs-primary);"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Reset Microsoft Authenticator</h4>
    <p class="mb-6">
      Masukkan password untuk mengkonfirmasi reset. Setelah itu, scan kode QR baru untuk mengatur ulang Authenticator.
    </p>

    <form id="resetConfirmForm" action="${url.loginAction}" method="post" novalidate>

      <!-- Password input -->
      <div class="mb-6 form-password-toggle">
        <label class="form-label" for="password">Password</label>
        <div class="input-group input-group-merge">
          <input type="password"
                 id="password"
                 name="password"
                 class="form-control"
                 placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;"
                 autocomplete="current-password"
                 autofocus />
          <span class="input-group-text cursor-pointer" id="togglePassword">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
        <div id="passwordError" class="invalid-feedback" style="display:none;">
          Password tidak boleh kosong.
        </div>
      </div>

      <div class="d-grid gap-3">
        <button id="submitBtn" class="btn btn-danger" type="submit">
          <span id="btnText"><i class="ti ti-refresh me-1"></i>Reset & Setup Ulang</span>
          <span id="btnLoader" style="display:none;">
            <span class="spinner-border spinner-border-sm me-2" role="status"></span>
            Memproses...
          </span>
        </button>
      </div>
    </form>

    <!-- Kembali ke pilihan MFA -->
    <form action="${url.loginAction}" method="post" class="mt-6">
      <input type="hidden" name="mfaMethod" value="BACK" />
      <button type="submit" class="btn btn-link text-dark small p-0">
        <i class="ti ti-arrow-left me-1"></i>Kembali ke metode verifikasi
      </button>
    </form>

    <script>
    document.addEventListener("DOMContentLoaded", function () {
      var form         = document.getElementById('resetConfirmForm');
      var passwordInput = document.getElementById('password');
      var passwordError = document.getElementById('passwordError');
      var toggleBtn    = document.getElementById('togglePassword');
      var submitBtn    = document.getElementById('submitBtn');
      var btnText      = document.getElementById('btnText');
      var btnLoader    = document.getElementById('btnLoader');

      // Toggle password visibility
      toggleBtn.addEventListener('click', function () {
        var type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        this.querySelector('i').classList.toggle('ti-eye');
        this.querySelector('i').classList.toggle('ti-eye-off');
      });

      // Clear error on input
      passwordInput.addEventListener('input', function () {
        passwordInput.classList.remove('is-invalid');
        passwordError.style.display = 'none';
      });

      // Form submit validation
      form.addEventListener('submit', function (e) {
        if (!passwordInput.value.trim()) {
          e.preventDefault();
          passwordInput.classList.add('is-invalid');
          passwordError.style.display = 'block';
          return;
        }

        // Show loading
        submitBtn.disabled   = true;
        btnText.style.display  = 'none';
        btnLoader.style.display = 'inline-block';
      });
    });
    </script>
  </#if>
</@layout.registrationLayout>
