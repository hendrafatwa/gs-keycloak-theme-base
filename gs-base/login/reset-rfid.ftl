<#import "template.ftl" as layout>

<@layout.registrationLayout title="Kartu RFID"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-id" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Kartu RFID</h4>
    <p class="mb-4">Tempelkan kartu identitas karyawan Anda pada reader.</p>

    <div class="text-center my-4">
      <img src="${url.resourcesPath}/assets/img/gs/rfid-card.gif"
           alt="Ilustrasi RFID"
           style="width: 100%; max-height: 320px; object-fit: contain;"
           onerror="this.style.display='none'" />
    </div>

    <form id="rfidForm" action="${url.loginAction}" method="post">
      <!-- Reader RFID bekerja sebagai keyboard: hasil scan diketik ke input
           tersembunyi ini, diakhiri Enter. -->
      <input type="text" id="rfid-input" name="rfid_card_id"
             style="opacity:0; position:absolute; left:-9999px;" autocomplete="off" />
    </form>

    <div class="text-center mb-4" id="statusText" style="display:none;">
      <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
      <span class="text-muted">Memverifikasi kartu...</span>
    </div>

    <form action="${url.loginAction}" method="post">
      <input type="hidden" name="rpAction" value="BACK_SELECT" />
      <button type="submit" class="btn btn-link text-dark small p-0">
        <i class="ti ti-arrow-left me-1"></i>Kembali ke Verifikasi Akun
      </button>
    </form>

    <script>
    (function () {
      const input  = document.getElementById('rfid-input');
      const form   = document.getElementById('rfidForm');
      const status = document.getElementById('statusText');

      function focusInput() {
        input.focus();
      }

      input.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.key === 'Tab') {
          e.preventDefault();
          if (this.value.trim()) {
            status.style.display = 'block';
            form.submit();
          }
        }
      });

      // Jaga fokus tetap di input tersembunyi — kalau hilang, hasil scan
      // tidak akan tertangkap.
      document.addEventListener('click', function (e) {
        if (!e.target.closest('button') && !e.target.closest('a')) {
          focusInput();
        }
      });

      setTimeout(focusInput, 200);
    })();
    </script>

  </#if>
</@layout.registrationLayout>
