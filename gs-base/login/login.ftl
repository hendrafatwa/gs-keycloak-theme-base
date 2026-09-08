<#import "template.ftl" as layout>
<#assign pageTitle = "Login">

<#-- Mode vendor: hanya username + password. Pilihan tipe user dan plant
     tidak ditampilkan. Diatur lewat config authenticator per realm. -->
<#assign isVendor = vendorMode!false>

<@layout.registrationLayout; section>
  <#if section == "form">

    <h4 class="mb-1 fw-bold">Halo!</h4>
    <p class="mb-6">Silakan sign in untuk melanjutkan.</p>

    <form id="formAuthentication"
          class="mb-6"
          action="${url.loginAction}"
          data-vendor-mode="${isVendor?c}"
          method="post"
          novalidate>

      <!-- Hidden username -->
      <input type="hidden" id="username" name="username" value="${(login?? && login.username??)?then(login.username,'')}">

      <#if !isVendor>
      <!-- Login Mode (Radio Button) -->
      <div class="mb-6">
        <label class="form-label d-block">Tipe User</label>
        <div class="d-flex gap-3">

          <label class="radio-card flex-fill" for="modeGSPORTAL">
            <input type="radio" name="loginMode" id="modeGSPORTAL" value="GSPORTAL"
                   <#if !(login?? && login.username?? && login.username?contains('__ldap__'))>checked</#if>>
            <span class="radio-card-body">
              <span class="radio-dot"></span>
              <span>Portal GS (NPK)</span>
            </span>
          </label>

          <label class="radio-card flex-fill" for="modeLDAP">
            <input type="radio" name="loginMode" id="modeLDAP" value="LDAP"
                   <#if (login?? && login.username?? && login.username?contains('__ldap__'))>checked</#if>>
            <span class="radio-card-body">
              <span class="radio-dot"></span>
              <span>LDAP (Komputer)</span>
            </span>
          </label>

        </div>
      </div>

      <!-- Plant (hanya muncul saat GSPORTAL) -->
      <div id="plantWrapper" class="mb-6">
        <label class="form-label d-block">Plant</label>
        <div class="d-flex gap-3" id="plantRadioGroup">

          <label class="radio-card flex-fill" for="plantKarawang">
            <input type="radio" name="plant" id="plantKarawang" value="k" checked>
            <span class="radio-card-body">
            <span class="radio-dot"></span>
            <span>Karawang</span>
            </span>
          </label>

          <label class="radio-card flex-fill" for="plantSemarang">
            <input type="radio" name="plant" id="plantSemarang" value="m">
            <span class="radio-card-body">
            <span class="radio-dot"></span>
            <span>Semarang</span>
            </span>
          </label>

          </div>
        <div id="plantError" class="invalid-feedback" style="display:none;">Plant harus dipilih.</div>
      </div>
      </#if>

      <!-- Username Display -->
      <div class="mb-6">
        <label for="usernameDisplay" class="form-label" id="usernameLabel">
          <#if isVendor>Username<#else>6-Digit NPK</#if>
        </label>
        <input type="text"
               class="form-control"
               id="usernameDisplay"
               placeholder="<#if isVendor>Username<#else>6-Digit NPK</#if>"
               autofocus
               autocomplete="off" />
        <div id="usernameError" class="invalid-feedback" style="display:none;">Username tidak boleh kosong.</div>
      </div>

      <!-- Password -->
      <div class="mb-6 form-password-toggle">
        <label class="form-label" for="password">Password</label>
        <div class="input-group input-group-merge">
          <input type="password"
                 id="password"
                 class="form-control"
                 name="password"
                 placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;"
                 autocomplete="current-password" />
          <span class="input-group-text cursor-pointer" id="togglePassword">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
        <div id="passwordError" class="invalid-feedback" style="display:none;">Password tidak boleh kosong.</div>
      </div>

      <!-- Remember Me -->
      <#if realm.rememberMe?? && realm.rememberMe>
        <div class="my-4">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe"
               <#if login?? && login.rememberMe?? && login.rememberMe>checked</#if>
            >
            <label class="form-check-label" for="rememberMe">Remember me</label>
          </div>
        </div>
      </#if>

      <!-- credentialId -->
      <#assign credId = (auth.selectedCredential)!''>
      <#if credId?has_content>
        <input type="hidden" name="credentialId" value="${credId}" />
      </#if>

      <div class="d-flex justify-content-end mb-4">
        <a href="${url.loginResetCredentialsUrl}" style="color: var(--gs-primary); font-size: 0.875rem;">
          Lupa password?
        </a>
      </div>

      <button class="btn btn-primary d-grid w-100" type="submit" id="submitBtn">
        Sign in
      </button>

    </form>

    <!-- Register (optional) -->
    <#if realm.registrationAllowed?? && realm.registrationAllowed>
      <p class="text-center">
        <span>Don't have an account?</span>
        <a href="${url.registrationUrl}"><span>Sign up</span></a>
      </p>
    </#if>

    <script>
    document.addEventListener("DOMContentLoaded", function () {

      var form            = document.getElementById('formAuthentication');
      var isVendor        = form.dataset.vendorMode === 'true';
      var plantWrapper    = document.getElementById('plantWrapper');
      var usernameDisplay = document.getElementById('usernameDisplay');
      var usernameHidden  = document.getElementById('username');
      var passwordInput   = document.getElementById('password');
      var submitBtn       = document.getElementById('submitBtn');
      var togglePassword  = document.getElementById('togglePassword');

      // ── Getter mode aktif ────────────────────────────────────────────────────
      function getLoginMode() {
        if (isVendor) return 'VENDOR';
        var checked = document.querySelector('input[name="loginMode"]:checked');
        return checked ? checked.value : 'GSPORTAL';
      }

      function getPlantValue() {
        var checked = document.querySelector('input[name="plant"]:checked');
        return checked ? checked.value : '';
      }

      // ── Error helpers ────────────────────────────────────────────────────────
      function showError(inputEl, errorEl) {
        if (!inputEl || !errorEl) return;
        inputEl.classList.add('is-invalid');
        errorEl.style.display = 'block';
      }

      function hideError(inputEl, errorEl) {
        if (!inputEl || !errorEl) return;
        inputEl.classList.remove('is-invalid');
        errorEl.style.display = 'none';
      }

      function clearAllErrors() {
        hideError(usernameDisplay, document.getElementById('usernameError'));
        hideError(passwordInput,   document.getElementById('passwordError'));
        hideError(document.getElementById('plantRadioGroup'), document.getElementById('plantError'));
      }

      // ── Toggle visibility password ───────────────────────────────────────────
      togglePassword.addEventListener('mousedown', function (e) {
        e.preventDefault();
      });

      togglePassword.addEventListener('click', function (e) {
        e.preventDefault();
        var icon = this.querySelector('i');
        var type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        passwordInput.setAttribute('type', type);
        icon.classList.toggle('ti-eye');
        icon.classList.toggle('ti-eye-off');

        setTimeout(function () {
          var len = passwordInput.value.length;
          passwordInput.focus();
          passwordInput.setSelectionRange(len, len);
        }, 0);
      });

      // ── Update placeholder username ──────────────────────────────────────────
      function updateUsernamePlaceholder() {
        if (isVendor) return;   // label sudah tetap "Username" dari server

        var label = document.getElementById('usernameLabel');
        if (getLoginMode() === 'GSPORTAL') {
          usernameDisplay.placeholder = '6-Digit NPK';
          label.textContent = 'NPK';
        } else {
          usernameDisplay.placeholder = 'Username';
          label.textContent = 'Username';
        }
      }

      // ── Compose username hidden field ────────────────────────────────────────
      function buildUsername() {
        usernameHidden.value = usernameDisplay.value.trim();
      }

      // ── Tampil/sembunyikan plant ─────────────────────────────────────────────
      function togglePlant() {
        if (isVendor) {
          buildUsername();
          return;
        }

        if (getLoginMode() === 'GSPORTAL') {
          plantWrapper.style.display = 'block';

          // reset ke Karawang setiap kali masuk GSPORTAL
          document.getElementById('plantKarawang').checked = true;
          hideError(document.getElementById('plantRadioGroup'), document.getElementById('plantError'));
        } else {
          plantWrapper.style.display = 'none';
          hideError(document.getElementById('plantRadioGroup'), document.getElementById('plantError'));
        }

        buildUsername();
        updateUsernamePlaceholder();
      }

      // ── Event listeners radio button ─────────────────────────────────────────
      if (!isVendor) {
        document.querySelectorAll('input[name="loginMode"]').forEach(function (radio) {
          radio.addEventListener('change', togglePlant);
        });

        document.querySelectorAll('input[name="plant"]').forEach(function (radio) {
          radio.addEventListener('change', function () {
            hideError(document.getElementById('plantRadioGroup'), document.getElementById('plantError'));
            buildUsername();
          });
        });
      }

      // ── Clear error on input ─────────────────────────────────────────────────
      usernameDisplay.addEventListener('input', function () {
        hideError(usernameDisplay, document.getElementById('usernameError'));
        buildUsername();
      });

      passwordInput.addEventListener('input', function () {
        hideError(passwordInput, document.getElementById('passwordError'));
      });

      // ── Submit validation ─────────────────────────────────────────────────────
      form.addEventListener('submit', function (e) {
        clearAllErrors();
        var hasError = false;

        if (!isVendor && getLoginMode() === 'GSPORTAL' && !getPlantValue()) {
          showError(document.getElementById('plantRadioGroup'), document.getElementById('plantError'));
          hasError = true;
        }

        if (!usernameDisplay.value.trim()) {
          showError(usernameDisplay, document.getElementById('usernameError'));
          hasError = true;
        }

        if (!passwordInput.value) {
          showError(passwordInput, document.getElementById('passwordError'));
          hasError = true;
        }

        if (hasError) {
          e.preventDefault();
          return;
        }

        buildUsername();
        submitBtn.disabled    = true;
        submitBtn.textContent = "Signing in...";
      });

      // ── Jalankan sekali saat load ─────────────────────────────────────────────
      togglePlant();

    });
    </script>
  </#if>
</@layout.registrationLayout>
