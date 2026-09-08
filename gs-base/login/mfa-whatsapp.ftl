<#import "template.ftl" as layout>

<@layout.registrationLayout title="Verifikasi WhatsApp"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-brand-whatsapp" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Verifikasi WhatsApp</h4>
    <p class="mb-4">Kirim pesan berisi kode key ke WhatsApp kami, lalu masukkan kode OTP yang dibalas.</p>

    <!-- ── Langkah 1: kirim pesan ────────────────────────────────────────── -->
    <div class="border rounded-3 p-4 mb-4" style="background-color: #f8f9fa;">
      <div class="d-flex align-items-center gap-2 mb-3">
        <span class="badge rounded-pill bg-primary">1</span>
        <span class="fw-semibold">Kirim pesan lewat WhatsApp</span>
      </div>

      <a href="${waDeepLink!""}" target="_blank" rel="noopener"
         class="btn btn-success d-grid w-100 mb-3" id="waLinkBtn">
        <span><i class="ti ti-brand-whatsapp me-1"></i>Buka WhatsApp</span>
      </a>

      <div class="text-center">
        <small class="text-muted d-block mb-2">
          WhatsApp tidak terbuka? Kirim manual dari HP ke
          <strong>+${waGateway!""}</strong> dengan pesan:
        </small>

        <div class="border rounded-2 bg-white p-3 text-start position-relative"
             style="font-size: 0.85rem;">

          <!-- Tombol salin menyalin SELURUH pesan, bukan hanya baris KEY,
               supaya user yang mengirim manual tidak perlu mengetik ulang. -->
          <button type="button" class="btn btn-sm btn-outline-secondary position-absolute"
                  style="top: 8px; right: 8px;"
                  onclick="copyPesan()" id="copyBtn" title="Salin pesan">
            <i class="ti ti-copy"></i>
          </button>

          <pre id="waPesanText" class="mb-0 text-dark" style="font-family: inherit;
               font-size: 0.85rem; white-space: pre-wrap; word-break: break-word;
               background: none; border: none; padding: 0; padding-right: 40px;"
>Permintaan Login - ${waAppName!""}

Saya ingin login ke ${waAppName!""}.
KEY: ${waLoginKey!""}

Mohon dikirimkan kode OTP untuk verifikasi login.</pre>
        </div>

        <small class="text-muted d-block mt-2">
          Pesan harus dikirim dari nomor <strong>${waPhoneMasked!""}</strong>
        </small>
      </div>
    </div>

    <!-- ── Langkah 2: masukkan OTP ───────────────────────────────────────── -->
    <div class="d-flex align-items-center gap-2 mb-3">
      <span class="badge rounded-pill bg-primary">2</span>
      <span class="fw-semibold">Masukkan kode OTP dari balasan WhatsApp</span>
    </div>

    <form id="waOtpForm" action="${url.loginAction}" method="post">

      <div class="mb-4">
        <div class="otp-wrapper">
          <input type="tel" class="form-control otp-input" maxlength="1" autofocus autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
        </div>
        <input type="hidden" id="wa_otp" name="wa_otp" />
        <small class="text-muted d-block text-center mt-2">
          Kode berlaku ${waValidMinutes!5} menit
        </small>
      </div>

      <button id="submitBtn" class="btn btn-primary d-grid w-100 mb-4" type="submit">
        <span id="btnText">Verifikasi</span>
        <span id="btnLoader" style="display:none;">
          <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
          Memverifikasi...
        </span>
      </button>
    </form>

    <!-- Buat key baru -->
    <form action="${url.loginAction}" method="post" class="mb-4">
      <input type="hidden" name="mfaMethod" value="RENEW_WA" />
      <button type="submit" class="btn btn-link text-dark small p-0">
        <i class="ti ti-refresh me-1"></i>Buat key baru
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
    </style>

    <script>
    // ── Salin key ke clipboard ────────────────────────────────────────────
    function copyPesan() {
      const text = document.getElementById('waPesanText').textContent;
      const btn  = document.getElementById('copyBtn');

      function done() {
        btn.innerHTML = '<i class="ti ti-check"></i>';
        setTimeout(function () { btn.innerHTML = '<i class="ti ti-copy"></i>'; }, 1500);
      }

      if (navigator.clipboard && window.isSecureContext) {
        navigator.clipboard.writeText(text).then(done).catch(fallbackCopy);
      } else {
        fallbackCopy();
      }

      // Fallback untuk halaman yang diakses lewat HTTP — navigator.clipboard
      // hanya tersedia di secure context (HTTPS / localhost)
      function fallbackCopy() {
        const ta = document.createElement('textarea');
        ta.value = text;
        ta.style.position = 'fixed';
        ta.style.opacity = '0';
        document.body.appendChild(ta);
        ta.select();
        try { document.execCommand('copy'); done(); } catch (e) {}
        document.body.removeChild(ta);
      }
    }

    // ── OTP input ─────────────────────────────────────────────────────────
    (function () {
      const inputs = document.querySelectorAll('.otp-input');
      const hiddenOtp = document.getElementById('wa_otp');
      const form = document.getElementById('waOtpForm');
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

      // Tidak auto-focus ke OTP di awal — user perlu klik tombol WhatsApp
      // dulu. Fokus baru dipindah setelah user kembali ke tab ini.
      document.getElementById('waLinkBtn').addEventListener('click', function () {
        setTimeout(() => inputs[0].focus(), 500);
      });
    })();
    </script>
  </#if>
</@layout.registrationLayout>
