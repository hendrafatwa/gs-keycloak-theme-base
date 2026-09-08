<#import "template.ftl" as layout>

<@layout.registrationLayout title="Tap RFID Card"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <img src="${url.resourcesPath}/assets/img/gs/id.svg" alt="icon" width="24" height="24">
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Kartu RFID</h4>
    <p class="mb-2">Tempelkan kartu identitas karyawan Anda pada reader.</p>

    <!-- <#if message?has_content && message.type == "error">
      <div class="alert alert-danger d-flex align-items-center gap-2 mt-2 mb-0" role="alert">
        <i class="ti ti-alert-circle"></i>
        <span>${message.summary?no_esc}</span>
      </div>
    </#if> -->

    <!-- Ilustrasi -->
    <div class="text-center my-6">
      <img src="${url.resourcesPath}/assets/img/gs/rfid-card.gif"
           alt="RFID Illustration"
          style="width: 100%; height: 400px; object-fit: cover;" 
           onerror="this.style.display='none'" />
    </div>

    <form id="rfidForm" action="${url.loginAction}" method="post">
      <!-- Input disembunyikan, diisi otomatis oleh keyboard emulation RFID reader -->
      <input type="text"
             id="rfid_card_id"
             name="rfid_card_id"
             value=""
             autocomplete="off"
             style="position: absolute; opacity: 0; width: 1px; height: 1px; pointer-events: none;"
             tabindex="-1" />
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
      var rfidInput  = document.getElementById('rfid_card_id');
      var rfidForm   = document.getElementById('rfidForm');
      var submitted  = false;

      rfidInput.value = '';
      rfidInput.focus();

      document.addEventListener('click', function (e) {
        if (!e.target.closest('form:not(#rfidForm)')) {
          rfidInput.focus();
        }
      });

      function submitRfid() {
        if (submitted) return;
        var cardId = rfidInput.value.trim();
        if (cardId.length > 0) {
          submitted = true;
          rfidForm.submit();
        }
      }

      rfidInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
          e.preventDefault();
          submitRfid();
        }
      });

      rfidInput.addEventListener('input', function () {
        var cardId = rfidInput.value.trim();
        if (cardId.length >= 10) {
          setTimeout(function () {
            submitRfid();
          }, 100);
        }
      });
    });
    </script>

    <!-- <script>
    document.addEventListener("DOMContentLoaded", function () {
      var rfidInput  = document.getElementById('rfid_card_id');
      var rfidForm   = document.getElementById('rfidForm');
      var submitted  = false;

      rfidInput.value = '';
      rfidInput.focus();

      // // Jika user klik di tempat lain, kembalikan focus ke input
      // // Kecuali klik pada tombol back
      // document.addEventListener('click', function (e) {
      //   if (!e.target.closest('form:not(#rfidForm)')) {
      //     rfidInput.focus();
      //   }
      // });

      // // RFID reader keyboard emulation biasanya diakhiri Enter
      // rfidInput.addEventListener('keydown', function (e) {
      //   if (e.key === 'Enter') {
      //     e.preventDefault();
      //     var cardId = rfidInput.value.trim();
      //     if (cardId.length > 0) {
      //       rfidForm.submit();
      //     }
      //   }
      // });

      // // Auto-submit jika panjang kartu sudah cukup (opsional, sesuaikan panjang kartu_id di DB)
      // rfidInput.addEventListener('input', function () {
      //   var cardId = rfidInput.value.trim();

      //   // Jika kartu_id punya panjang tetap (misal 10 karakter), auto-submit
      //   // Sesuaikan angka 10 dengan panjang kartu_id di DB Anda
      //   if (cardId.length >= 10) {
      //     setTimeout(function () {
      //       rfidForm.submit();
      //     }, 100);
      //   }
      // });

      function submitRfid() {       // ← tambah function ini
  if (submitted) return;
  var cardId = rfidInput.value.trim();
  if (cardId.length > 0) {
    submitted = true;
    rfidForm.submit();
  }
}

rfidInput.addEventListener('keydown', function (e) {
  if (e.key === 'Enter') {
    e.preventDefault();
    submitRfid();  // ← ganti
  }
});

rfidInput.addEventListener('input', function () {
  var cardId = rfidInput.value.trim();
  if (cardId.length >= 10) {
    setTimeout(function () {
      submitRfid();  // ← ganti
    }, 100);
  }
});
    });
    </script> -->
  </#if>
</@layout.registrationLayout>
