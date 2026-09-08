<#import "template.ftl" as layout>

<@layout.registrationLayout title="Set up Authenticator"; section>
  <#if section == "form">

    <#-- Pesan error jika ada -->
    <!-- <#if message?has_content && (message.type = 'error')>
      <div class="alert alert-danger" role="alert">
        <strong>Error:</strong> ${kcSanitize(message.summary)?no_esc}
      </div>
    </#if> -->

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-fingerprint" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Pengaturan Microsoft Authenticator</h4>
    <p class="mb-6">
      Siapkan Microsoft Authenticator untuk mengaktifkan akun Anda.
      Scan kode QR dibawah lalu masukkan kode verifikasi 6 digit.
    </p>

    <!-- QR CODE -->
    <!-- <div class="text-center mb-6">
      <#if totp.totpSecretQrCode??>
        <img src="data:image/png;base64,${totp.totpSecretQrCode}" alt="QR Code" style="max-width: 250px;" />
      </#if>
      
      <p class="mt-2 text-muted">
        Tidak bisa scan? Pakai kode ini:
        <#if totp.totpSecretEncoded??>
          <span class="fw-bold">${totp.totpSecretEncoded}</span>
        </#if>
      </p>
    </div> -->

    <div class="d-flex align-items-center gap-3 mb-6">
      <#if totp.totpSecretQrCode??>
        <img src="data:image/png;base64,${totp.totpSecretQrCode}" alt="QR Code" style="width: 140px; height: 140px; flex-shrink: 0;" />
      </#if>
      <div>
        <p class="text-muted mb-1" style="font-size: 0.85rem;">Tidak bisa scan? Pakai kode ini:</p>
        <#if totp.totpSecretEncoded??>
          <span class="fw-bold" style="font-size: 0.85rem; word-break: break-all;">${totp.totpSecretEncoded}</span>
        </#if>
      </div>
    </div>

    <form id="totpForm" action="${url.loginAction}" method="post">
      
      <!-- CRITICAL: Hidden fields untuk Keycloak 26 -->
      <input type="hidden" id="totpSecret" name="totpSecret" value="${totp.totpSecret}" />
      <input type="hidden" id="mode" name="mode" value="totp"/>

      <!-- DEVICE NAME INPUT -->
      <div class="mb-4">
        <label for="userLabel" class="form-label">Nama Device</label>
        <input type="text" 
               id="userLabel" 
               name="userLabel" 
               class="form-control" 
               placeholder="e.g., My Phone" 
               value="Mobile Authenticator"
               required />
      </div>

      <!-- OTP BOXES -->
      <!-- <div class="mb-6">
        <label class="form-label">Kode Verifikasi</label>
        <div class="auth-input-wrapper d-flex justify-content-between">
          <input type="tel" class="form-control auth-input text-center otp-input" maxlength="1" autofocus autocomplete="off" />
          <input type="tel" class="form-control auth-input text-center otp-input" maxlength="1" autocomplete="off" />
          <input type="tel" class="form-control auth-input text-center otp-input" maxlength="1" autocomplete="off" />
          <input type="tel" class="form-control auth-input text-center otp-input" maxlength="1" autocomplete="off" />
          <input type="tel" class="form-control auth-input text-center otp-input" maxlength="1" autocomplete="off" />
          <input type="tel" class="form-control auth-input text-center otp-input" maxlength="1" autocomplete="off" />
        </div>

        <input type="hidden" id="totp" name="totp" />
      </div> -->

      <!-- OTP BOXES -->
      <div class="mb-6">
        <label class="form-label">Kode Verifikasi</label>
        <div class="otp-wrapper">
          <input type="tel" class="form-control otp-input" maxlength="1" autofocus autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
        </div>

        <!-- OTP untuk Keycloak -->
        <input type="hidden" id="totp" name="totp" />
      </div>

      <button id="submitBtn" class="btn btn-primary d-grid w-100" type="submit">
        <span id="btnText">Verifikasi & Aktifkan</span>
        <span id="btnLoader" style="display: none;">
          <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
          Memverifikasi...
        </span>
      </button>
    </form>

     <!-- Kembali ke Sign In -->
    <div class="mt-6">
     <a href="${url.loginRestartFlowUrl}" class="text-dark d-inline-flex align-items-center gap-1" style="text-decoration: none;">
        <i class="ti ti-arrow-left" style="font-size: 14px;"></i>
        Kembali ke Sign In
      </a>
    </div>

    <!-- JS: gabungkan 6 box + PASTE support + UX improvements -->
    <script>
      (function () {
        const inputs = document.querySelectorAll('.otp-input');
        const hiddenOtp = document.getElementById('totp');
        const form = document.getElementById('totpForm');
        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');
        const btnLoader = document.getElementById('btnLoader');

        function updateOtp() {
          let v = '';
          inputs.forEach(i => v += i.value || '');
          hiddenOtp.value = v;
          
          // Auto-submit ketika 6 digit sudah terisi
          if (v.length === 6) {
            setTimeout(() => {
			  showLoading();
              form.submit();
            }, 300); // Delay 300ms untuk UX yang lebih smooth
          }
        }
		
		function showLoading() {
		  submitBtn.disabled = true;
		  submitBtn.classList.add('disabled');        // ← tambahkan
		  submitBtn.style.backgroundColor = '#6c757d'; // ← tambahkan
		  submitBtn.style.borderColor = '#6c757d';     // ← tambahkan
		  submitBtn.style.cursor = 'not-allowed';      // ← tambahkan
		  btnText.style.display = 'none';
		  btnLoader.style.display = 'inline-block';
		}

        inputs.forEach((input, idx) => {
          // Handle typing
          input.addEventListener('input', function () {
            this.value = this.value.replace(/[^0-9]/g, '');
            
            if (this.value && idx < inputs.length - 1) {
              inputs[idx + 1].focus();
            }
            
            updateOtp();
          });

          // Handle backspace
          input.addEventListener('keydown', function (e) {
            // Backspace: pindah ke input sebelumnya
            if (e.key === 'Backspace' && !this.value && idx > 0) {
              inputs[idx - 1].focus();
            }
            
            // Enter: submit form
            if (e.key === 'Enter') {
              e.preventDefault();
              updateOtp();
              if (hiddenOtp.value.length === 6) {
                form.submit();
              } else {
                alert('Please enter all 6 digits');
              }
            }
            
            // Arrow left/right navigation
            if (e.key === 'ArrowLeft' && idx > 0) {
              e.preventDefault();
              inputs[idx - 1].focus();
              inputs[idx - 1].select();
            }
            if (e.key === 'ArrowRight' && idx < inputs.length - 1) {
              e.preventDefault();
              inputs[idx + 1].focus();
              inputs[idx + 1].select();
            }
          });

          // Handle PASTE
          input.addEventListener('paste', function (e) {
            e.preventDefault();
            const pastedData = e.clipboardData.getData('text').replace(/[^0-9]/g, '');
            
            if (pastedData.length === 6) {
              // Paste 6 digit code
              for (let i = 0; i < 6; i++) {
                if (inputs[i]) {
                  inputs[i].value = pastedData[i] || '';
                }
              }
              inputs[5].focus();
              updateOtp();
            } else if (pastedData.length > 0) {
              // Paste partial code
              let currentIdx = idx;
              for (let i = 0; i < pastedData.length && currentIdx < 6; i++) {
                inputs[currentIdx].value = pastedData[i];
                currentIdx++;
              }
              if (currentIdx < 6) {
                inputs[currentIdx].focus();
              } else {
                inputs[5].focus();
              }
              updateOtp();
            }
          });

          // Double-click to select all (untuk edit mudah)
          input.addEventListener('dblclick', function () {
            this.select();
          });

          // Focus event: select content
          input.addEventListener('focus', function () {
            this.select();
          });
        });

        // Form submit handler
        form.addEventListener('submit', function(e) {
          updateOtp();
          
          const otpValue = hiddenOtp.value;
          
          if (otpValue.length !== 6) {
            e.preventDefault();
            alert('Please enter all 6 digits of the verification code');
            inputs[0].focus();
            return false;
          }
          
          // Show loading state
          submitBtn.disabled = true;
          btnText.style.display = 'none';
          btnLoader.style.display = 'inline-block';
        });

        // Initial focus
        updateOtp();
        
        // Focus pertama kali pada input pertama
        setTimeout(() => {
          inputs[0].focus();
        }, 100);
      })();
    </script>

  </#if>
</@layout.registrationLayout>