<#import "template.ftl" as layout>

<@layout.registrationLayout title="Two Step Verification"; section>
  <#if section == "form">
    
    <#-- Error message -->
    <#if message?has_content && (message.type = 'error')>
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
        <i class="ti ti-alert-circle me-2"></i>
        <strong>Error:</strong> ${kcSanitize(message.summary)?no_esc}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    </#if>

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-fingerprint" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Microsoft Authenticator</h4>
    <p class="mb-6">
      Enter the verification code from your Microsoft Authenticator app.
    </p>

    <p class="mb-2">Verification code</p>

    <form id="otpForm" class="mb-6" action="${url.loginAction}" method="post">

      <!-- OTP BOXES -->
      <div class="mb-6">
        <div class="auth-input-wrapper d-flex align-items-center justify-content-between numeral-mask-wrapper">
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autofocus autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
        </div>

        <!-- OTP yang dibaca Keycloak -->
        <input type="hidden" id="otp" name="otp" />
      </div>

      <!-- credentialId (penting kalau user punya >1 OTP) -->
      <#if auth.selectedCredential??>
        <input type="hidden" name="credentialId" value="${auth.selectedCredential}" />
      </#if>

      <button id="submitBtn" class="btn btn-primary d-grid w-100 mb-6" type="submit">
        <span id="btnText">Confirm</span>
        <span id="btnLoader" style="display: none;">
          <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
          Verifying...
        </span>
      </button>

    </form>

    <!-- JS OTP HANDLER with Enhanced UX -->
    <script>
      (function () {
        const inputs = document.querySelectorAll('.otp-input');
        const hiddenOtp = document.getElementById('otp');
        const form = document.getElementById('otpForm');
        const submitBtn = document.getElementById('submitBtn');
        const btnText = document.getElementById('btnText');
        const btnLoader = document.getElementById('btnLoader');

        if (!inputs.length || !hiddenOtp || !form) return;

        // Update OTP value
        function updateOtpValue() {
          let otp = '';
          inputs.forEach(input => otp += input.value || '');
          hiddenOtp.value = otp;

          // Auto-submit when 6 digits are filled
          if (otp.length === 6) {
            setTimeout(() => {
              showLoading();
              form.submit();
            }, 300); // Small delay for better UX
          }
        }

        // Show loading state
       function showLoading() {
		  submitBtn.disabled = true;
		  submitBtn.classList.add('disabled');        // ← tambahkan
		  submitBtn.style.backgroundColor = '#6c757d'; // ← tambahkan
		  submitBtn.style.borderColor = '#6c757d';     // ← tambahkan
		  submitBtn.style.cursor = 'not-allowed';      // ← tambahkan
		  btnText.style.display = 'none';
		  btnLoader.style.display = 'inline-block';
		}

        // Clear all inputs
        function clearInputs() {
          inputs.forEach(input => input.value = '');
          hiddenOtp.value = '';
          inputs[0].focus();
        }

        // Add shake animation on error
        function shakeInputs() {
          const wrapper = document.querySelector('.auth-input-wrapper');
          wrapper.style.animation = 'shake 0.5s';
          setTimeout(() => {
            wrapper.style.animation = '';
          }, 500);
        }

        inputs.forEach((input, index) => {

          // Handle input
          input.addEventListener('input', function () {
            // Only numbers
            this.value = this.value.replace(/[^0-9]/g, '');

            // Move to next input
            if (this.value && index < inputs.length - 1) {
              inputs[index + 1].focus();
            }

            updateOtpValue();
          });

          // Handle keyboard navigation
          input.addEventListener('keydown', function (e) {
            // Backspace: move to previous input
            if (e.key === 'Backspace') {
              if (!this.value && index > 0) {
                inputs[index - 1].focus();
              }
            }

            // Enter: submit form
            if (e.key === 'Enter') {
              e.preventDefault();
              updateOtpValue();
              if (hiddenOtp.value.length === 6) {
                showLoading();
                form.submit();
              } else {
                shakeInputs();
                alert('Please enter all 6 digits');
              }
            }

            // Arrow Left: previous input
            if (e.key === 'ArrowLeft' && index > 0) {
              e.preventDefault();
              inputs[index - 1].focus();
              inputs[index - 1].select();
            }

            // Arrow Right: next input
            if (e.key === 'ArrowRight' && index < inputs.length - 1) {
              e.preventDefault();
              inputs[index + 1].focus();
              inputs[index + 1].select();
            }

            // Delete: clear current and stay
            if (e.key === 'Delete') {
              this.value = '';
              updateOtpValue();
            }
          });

          // Paste support
          input.addEventListener('paste', function (e) {
            e.preventDefault();
            const paste = (e.clipboardData || window.clipboardData)
              .getData('text')
              .replace(/[^0-9]/g, '')
              .slice(0, inputs.length);

            paste.split('').forEach((char, i) => {
              if (inputs[i]) inputs[i].value = char;
            });

            // Focus on last filled input
            const lastIndex = Math.min(paste.length - 1, inputs.length - 1);
            inputs[lastIndex]?.focus();
            
            updateOtpValue();
          });

          // Select on focus
          input.addEventListener('focus', function () {
            this.select();
          });

          // Double-click to clear all and restart
          input.addEventListener('dblclick', function () {
            clearInputs();
          });
        });

        // Form submit validation
        form.addEventListener('submit', function (e) {
          updateOtpValue();
          
          if (hiddenOtp.value.length !== inputs.length) {
            e.preventDefault();
            shakeInputs();
            alert('Please enter the complete 6-digit code');
            return false;
          }

          showLoading();
        });

        // Auto-focus first input on load
        setTimeout(() => {
          inputs[0].focus();
        }, 100);

        // Keyboard shortcut: Ctrl/Cmd + K to clear all
        document.addEventListener('keydown', function (e) {
          if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            clearInputs();
          }
        });

      })();
    </script>

    <!-- CSS for shake animation -->
    <style>
      @keyframes shake {
        0%, 100% { transform: translateX(0); }
        10%, 30%, 50%, 70%, 90% { transform: translateX(-5px); }
        20%, 40%, 60%, 80% { transform: translateX(5px); }
      }

      .otp-input:focus {
        border-color: #696cff !important;
        box-shadow: 0 0 0 0.2rem rgba(105, 108, 255, 0.25) !important;
      }

      .otp-input.error {
        border-color: #ff3e1d !important;
        animation: shake 0.5s;
      }
    </style>

  </#if>
</@layout.registrationLayout>