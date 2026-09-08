<#import "template.ftl" as layout>

<@layout.registrationLayout title="Tap RFID Card"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-fingerprint" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">RFID Card</h4>
    <p class="mb-2">Tap your RFID card on the reader for verification.</p>

    <!-- Animasi menunggu tap -->
    <div class="text-center my-6" id="waitingAnimation">
      <div class="d-inline-flex align-items-center justify-content-center rounded-circle"
           style="width: 96px; height: 96px; border: 3px dashed #ED3237; animation: pulse 1.5s infinite;">
        <i class="ti ti-credit-card" style="font-size: 48px; color: #ED3237;"></i>
      </div>
      <p class="mt-3 text-muted" id="statusText">Menunggu kartu...</p>
    </div>

    <form id="rfidForm" action="${url.loginAction}" method="post">
      <!-- RFID reader (keyboard emulation) akan mengisi field ini -->
      <input type="text"
             id="rfid_card_id"
             name="rfid_card_id"
             class="form-control"
             placeholder="Tap kartu RFID..."
             value=""
             autocomplete="off"
             style="text-align: center; letter-spacing: 4px; font-size: 1.2rem;"
             autofocus />
      <div id="rfidError" class="invalid-feedback" style="display:none;">
        Kartu tidak terbaca. Silakan coba lagi.
      </div>
    </form>

    <!-- Kembali ke pilihan MFA -->
    <form action="${url.loginAction}" method="post" class="text-center mt-4">
      <input type="hidden" name="mfaMethod" value="BACK" />
      <button type="submit" class="btn btn-link text-muted small p-0">
        <i class="ti ti-arrow-left me-1"></i>Back to Verification Method.
      </button>
    </form>

    <style>
      @keyframes pulse {
        0%, 100% { transform: scale(1); opacity: 1; }
        50%       { transform: scale(1.05); opacity: 0.7; }
      }
    </style>

    <script>
    document.addEventListener("DOMContentLoaded", function () {
      var rfidInput  = document.getElementById('rfid_card_id');
      var rfidForm   = document.getElementById('rfidForm');
      var statusText = document.getElementById('statusText');

      // Clear input saat halaman load (termasuk setelah error)
      rfidInput.value = '';
      rfidInput.focus();
      
      // Selalu focus ke input agar keyboard emulation langsung masuk
      rfidInput.focus();

      // Jika user klik di tempat lain, kembalikan focus ke input
      document.addEventListener('click', function () {
        rfidInput.focus();
      });

      // RFID reader keyboard emulation biasanya diakhiri Enter
      rfidInput.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
          e.preventDefault();
          var cardId = rfidInput.value.trim();
          if (cardId.length > 0) {
            statusText.textContent = 'Kartu terbaca, memverifikasi...';
            statusText.style.color = '#ED3237';
            rfidForm.submit();
          }
        }
      });

      // Auto-submit jika panjang kartu sudah cukup (opsional, sesuaikan panjang kartu_id di DB)
      rfidInput.addEventListener('input', function () {
        var cardId = rfidInput.value.trim();
        statusText.textContent = 'Membaca kartu...';

        // Jika kartu_id punya panjang tetap (misal 10 karakter), auto-submit
        // Sesuaikan angka 10 dengan panjang kartu_id di DB Anda
        if (cardId.length >= 10) {
          setTimeout(function () {
            statusText.textContent = 'Kartu terbaca, memverifikasi...';
            rfidForm.submit();
          }, 100);
        }
      });
    });
    </script>
  </#if>
</@layout.registrationLayout>
