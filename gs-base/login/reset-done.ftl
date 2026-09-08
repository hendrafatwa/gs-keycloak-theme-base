<#import "template.ftl" as layout>

<@layout.registrationLayout title="Password Berhasil Diubah"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-mood-smile" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Password Berhasil Diubah!</h4>
    <p class="mb-6">Silakan masuk kembali menggunakan password baru Anda.</p>

    <a href="${url.loginUrl}" id="signInBtn" class="btn btn-primary d-grid w-100">
      Sign In
    </a>

    <p id="redirectText" class="text-center text-muted mt-3 small">
      Dialihkan dalam 5 detik...
    </p>

    <script>
    (function () {
      // url.loginUrl mengarah ke halaman login untuk client yang sama,
      // jadi user kembali ke portal asalnya tanpa perlu URL di-hardcode.
      const target = document.getElementById('signInBtn').getAttribute('href');
      const text   = document.getElementById('redirectText');
      let sisa = 5;

      const timer = setInterval(function () {
        sisa -= 1;
        if (sisa <= 0) {
          clearInterval(timer);
          window.location.href = target;
          return;
        }
        text.textContent = 'Dialihkan dalam ' + sisa + ' detik...';
      }, 1000);
    })();
    </script>

  </#if>
</@layout.registrationLayout>
