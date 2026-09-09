<#import "template.ftl" as layout>

<@layout.registrationLayout title="Ganti Password"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-shield-lock" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Ganti Password Anda</h4>
    <p class="mb-4">
      Akun Anda masih menggunakan password awal. Untuk keamanan, silakan buat
      password baru sebelum melanjutkan.
    </p>

    <form id="fcpForm" action="${url.loginAction}" method="post">
      <!-- Syarat password: berubah warna saat mengetik, bukan menunggu tombol
           ditekan. Merah = belum terpenuhi, hijau = sudah. -->
      <div class="border rounded-3 p-3 mb-6" style="background-color: #f8f9fa;">
        <div class="fw-semibold mb-2" style="font-size: 0.85rem;">
          Syarat password
        </div>
        <ul class="list-unstyled mb-0" id="syaratList" style="font-size: 0.85rem;">
          <li class="mb-1 syarat" data-rule="length">
            <i class="ti ti-circle me-1"></i><span>Minimal ${minPasswordLength!12} karakter</span>
          </li>
          <li class="mb-1 syarat" data-rule="upper">
            <i class="ti ti-circle me-1"></i><span>Mengandung huruf besar (A-Z)</span>
          </li>
          <li class="mb-1 syarat" data-rule="lower">
            <i class="ti ti-circle me-1"></i><span>Mengandung huruf kecil (a-z)</span>
          </li>
          <li class="mb-1 syarat" data-rule="digit">
            <i class="ti ti-circle me-1"></i><span>Mengandung angka (0-9)</span>
          </li>
          <li class="mb-0 syarat" data-rule="symbol">
            <i class="ti ti-circle me-1"></i><span>Mengandung simbol (!@#$%^&amp;*-_ dll)</span>
          </li>
        </ul>
      </div>
      
      <div class="mb-4">
        <label class="form-label" for="passwordBaru">Password Baru</label>
        <div class="input-group input-group-merge">
          <input type="password" id="passwordBaru" name="passwordBaru"
                 class="form-control" autofocus autocomplete="new-password"
                 placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" />
          <span class="input-group-text cursor-pointer toggle-password">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
      </div>

      <div class="mb-6">
        <label class="form-label" for="passwordKonfirmasi">Konfirmasi Password Baru</label>
        <div class="input-group input-group-merge">
          <input type="password" id="passwordKonfirmasi" name="passwordKonfirmasi"
                 class="form-control" autocomplete="new-password"
                 placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;" />
          <span class="input-group-text cursor-pointer toggle-password">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
        <small id="matchHint" class="text-danger" style="display:none;">
          Password tidak sama
        </small>
      </div>

      <button id="submitBtn" class="btn btn-primary d-grid w-100" type="submit">
        <span id="btnText">Simpan &amp; Lanjutkan</span>
        <span id="btnLoader" style="display:none;">
          <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
          Menyimpan...
        </span>
      </button>
    </form>

    <style>
      #submitBtn:disabled {
        background-color: #6c757d !important;
        border-color: #6c757d !important;
        cursor: not-allowed !important;
        opacity: 0.65;
      }
      /* Abu-abu sebelum user mulai mengetik — merah semua sejak awal
         terasa seperti menuduh padahal belum ada yang diisi. */
      .syarat       { color: #6c757d; }
      .syarat.belum { color: #dc3545; }
      .syarat.sudah { color: #198754; }
    </style>

    <script>
    (function () {
      const form       = document.getElementById('fcpForm');
      const baru       = document.getElementById('passwordBaru');
      const konfirmasi = document.getElementById('passwordKonfirmasi');
      const matchHint  = document.getElementById('matchHint');
      const submitBtn  = document.getElementById('submitBtn');
      const btnText    = document.getElementById('btnText');
      const btnLoader  = document.getElementById('btnLoader');
      const minLength  = ${minPasswordLength!12};

      const items = document.querySelectorAll('#syaratList .syarat');

      function periksa(pwd) {
        return {
          length: pwd.length >= minLength,
          upper:  /[A-Z]/.test(pwd),
          lower:  /[a-z]/.test(pwd),
          digit:  /[0-9]/.test(pwd),
          symbol: /[^A-Za-z0-9]/.test(pwd)
        };
      }

      function render() {
        const pwd    = baru.value;
        const hasil  = periksa(pwd);
        const kosong = pwd.length === 0;

        items.forEach(function (li) {
          const rule = li.getAttribute('data-rule');
          const ikon = li.querySelector('i');

          li.classList.remove('belum', 'sudah');

          if (kosong) {
            ikon.className = 'ti ti-circle me-1';
            return;
          }

          if (hasil[rule]) {
            li.classList.add('sudah');
            ikon.className = 'ti ti-circle-check me-1';
          } else {
            li.classList.add('belum');
            ikon.className = 'ti ti-circle-x me-1';
          }
        });

        return Object.values(hasil).every(Boolean);
      }

      function cekCocok() {
        if (!konfirmasi.value) {
          matchHint.style.display = 'none';
          return false;
        }
        const cocok = baru.value === konfirmasi.value;
        matchHint.style.display = cocok ? 'none' : 'block';
        return cocok;
      }

      baru.addEventListener('input', function () {
        render();
        if (konfirmasi.value) cekCocok();
      });

      konfirmasi.addEventListener('input', cekCocok);

      // Pemeriksaan di sini hanya untuk kenyamanan — validasi sebenarnya
      // dilakukan di Keycloak dan ditegakkan sekali lagi di API.
      form.addEventListener('submit', function (e) {
        const syaratOk = render();
        const cocokOk  = cekCocok();

        if (!syaratOk) {
          e.preventDefault();
          baru.focus();
          return;
        }
        if (!cocokOk) {
          e.preventDefault();
          konfirmasi.focus();
          return;
        }

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
