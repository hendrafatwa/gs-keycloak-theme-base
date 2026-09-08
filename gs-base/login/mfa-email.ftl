<#import "template.ftl" as layout>

<@layout.registrationLayout title="Verifikasi Email"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-mail" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Verifikasi Email</h4>
    <p class="mb-6">Masukkan kode verifikasi 6 digit yang dikirim ke <strong>${emailMasked!""}</strong>.</p>

    <form id="emailOtpForm" action="${url.loginAction}" method="post">

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
        <input type="hidden" id="email_otp" name="email_otp" />
      </div>

      <button id="submitBtn" class="btn btn-primary d-grid w-100 mb-4" type="submit">
        <span id="btnText">Verifikasi</span>
        <span id="btnLoader" style="display:none;">
          <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
          Memverifikasi...
        </span>
      </button>
    </form>

    <!-- Kirim Ulang Kode -->
    <form id="resendForm" action="${url.loginAction}" method="post" class="mb-4">
      <input type="hidden" name="mfaMethod" value="RESEND_EMAIL" />
      <button id="resendBtn" type="submit" class="btn btn-link text-dark small p-0" data-cooldown="${resendCooldownSeconds!0}">
        <i class="ti ti-refresh me-1"></i><span id="resendBtnText">Kirim ulang kode</span>
      </button>
    </form>

    <!-- Kembali ke pilihan MFA -->
    <form action="${url.loginAction}" method="post" class="mt-2">
      <input type="hidden" name="mfaMethod" value="BACK" />
      <button type="submit" class="btn btn-link text-dark small p-0">
        <i class="ti ti-arrow-left me-1"></i>Kembali ke metode verifikasi
      </button>
    </form>

    <style>
      #submitBtn:disabled {
        background-color: #6c757d !important;
        border-color: #6c757d !important;
        cursor: not-allowed !important;
        opacity: 0.65;
      }
      #resendBtn:disabled {
        color: #6c757d !important;
        cursor: not-allowed !important;
        text-decoration: none !important;
        opacity: 0.7;
      }
    </style>

    <script>
    (function () {
      const inputs = document.querySelectorAll('.otp-input');
      const hiddenOtp = document.getElementById('email_otp');
      const form = document.getElementById('emailOtpForm');
      const submitBtn = document.getElementById('submitBtn');
      const btnText = document.getElementById('btnText');
      const btnLoader = document.getElementById('btnLoader');

      function showLoading() {
        submitBtn.disabled = true;
        btnText.style.display = 'none';
        btnLoader.style.display = 'inline-block';
      }

      function updateOtp() {
        let v = '';
        inputs.forEach(i => v += i.value || '');
        hiddenOtp.value = v;
        if (v.length === 6) {
          setTimeout(() => {
            showLoading();
            form.submit();
          }, 300);
        }
      }

      inputs.forEach((input, idx) => {
        input.addEventListener('input', function () {
          this.value = this.value.replace(/[^0-9]/g, '');
          if (this.value && idx < inputs.length - 1) inputs[idx + 1].focus();
          updateOtp();
        });

        input.addEventListener('keydown', function (e) {
          if (e.key === 'Backspace' && !this.value && idx > 0) inputs[idx - 1].focus();
        });

        input.addEventListener('paste', function (e) {
          e.preventDefault();
          const paste = e.clipboardData.getData('text').replace(/[^0-9]/g, '');
          paste.split('').forEach((c, i) => { if (inputs[i]) inputs[i].value = c; });
          inputs[Math.min(paste.length - 1, 5)].focus();
          updateOtp();
        });

        input.addEventListener('focus', function () { this.select(); });
      });

      form.addEventListener('submit', function () {
        updateOtp();
        showLoading();
      });

      setTimeout(() => inputs[0].focus(), 100);
    })();

    // ── Countdown tombol "Kirim ulang kode" ──────────────────────────────────
    // PENTING: angka awal (data-cooldown) sudah dihitung di SERVER berdasarkan
    // jam server. Di sini kita cuma hitung mundur angka itu detik demi detik
    // pakai setInterval — tidak membandingkan jam device user dengan jam server
    // sama sekali, jadi tidak terpengaruh biarpun jam di HP/PC user salah.
    (function () {
      const resendBtn = document.getElementById('resendBtn');
      const resendBtnText = document.getElementById('resendBtnText');
      let remaining = parseInt(resendBtn.getAttribute('data-cooldown'), 10) || 0;

      function render() {
        if (remaining > 0) {
          resendBtn.disabled = true;
          resendBtnText.textContent = 'Kirim ulang dalam ' + remaining + ' detik';
        } else {
          resendBtn.disabled = false;
          resendBtnText.textContent = 'Kirim ulang kode';
        }
      }

      render();

      const timer = setInterval(function () {
        remaining -= 1;
        if (remaining <= 0) {
          remaining = 0;
          clearInterval(timer);
        }
        render();
      }, 1000);
    })();
    </script>
  </#if>
</@layout.registrationLayout>
