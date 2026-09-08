<#import "template.ftl" as layout>

<@layout.registrationLayout title="Verifikasi MFA"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-fingerprint" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Verifikasi Akun</h4>
    <p class="mb-6">
      <#if waOnlyMode!false>
        Verifikasi melalui WhatsApp untuk melanjutkan
      <#else>
        Pilih metode verifikasi untuk melanjutkan
      </#if>
    </p>

    <form id="mfaSelectForm" action="${url.loginAction}" method="post">
      <input type="hidden" name="mfaMethod" id="mfaMethod" value="" />
    </form>

    <#if !(waOnlyMode!false)>
      <!-- Microsoft Authenticator -->
          <div class="mb-3">
            <button type="button"
                    class="btn btn-outline-secondary w-100 py-4 text-center"
                    onclick="selectMethod('TOTP')"
                    style="border-color: #ccc;">
              <div class="d-flex flex-column align-items-center gap-2">
                <img src="${url.resourcesPath}/assets/img/gs/device-mobile-message.svg" alt="icon" width="24" height="24">
                <div class="fw-semibold">Microsoft Authenticator</div>
                <small class="text-muted">Masukkan kode verifikasi 6 digit dari Microsoft Authenticator</small>
                <div class="text-center mt-2">
                  <span class="text-danger" style="font-size: 0.8rem;">Tidak bisa akses? </span>
                  <a href="#"
                    onclick="event.stopPropagation(); selectMethod('RESET'); return false;"
                    class="text-danger" style="font-size: 0.8rem; text-decoration: underline;">
                    Reset di sini.
                  </a>
                </div>
              </div>
            </button>
          </div>

      <!-- Kartu RFID -->
          <div class="mb-3">
            <button type="button"
                    class="btn btn-outline-secondary w-100 py-4 text-center"
                    onclick="selectMethod('RFID')"
                    style="border-color: #ccc;">
              <div class="d-flex flex-column align-items-center gap-2">
                <img src="${url.resourcesPath}/assets/img/gs/id.svg" alt="icon" width="24" height="24">
                <div class="fw-semibold">Kartu RFID</div>
                <small class="text-muted">Tempelkan kartu identitas karyawan Anda pada reader</small>
              </div>
            </button>
          </div>

          <!-- Kirim OTP ke Email -->
          <div class="mb-3">
            <button type="button"
                    class="btn btn-outline-secondary w-100 py-4 text-center"
                    onclick="selectMethod('EMAIL')"
                    style="border-color: #ccc;">
              <div class="d-flex flex-column align-items-center gap-2">
                <i class="ti ti-mail" style="font-size: 24px;"></i>
                <div class="fw-semibold">Email</div>
                <small class="text-muted">Masukkan kode verifikasi 6 digit dari Email</small>
              </div>
            </button>
          </div>
    </#if>

    <!-- Kirim OTP ke WhatsApp -->
    <#if waAvailable!false>
    <div class="mb-6">
      <button type="button"
              class="btn btn-outline-secondary w-100 py-4 text-center"
              onclick="selectMethod('WA')"
              style="border-color: #ccc;">
        <div class="d-flex flex-column align-items-center gap-2">
          <i class="ti ti-brand-whatsapp" style="font-size: 24px;"></i>
          <div class="fw-semibold">WhatsApp</div>
          <small class="text-muted">Kirim pesan ke WhatsApp kami untuk menerima kode verifikasi</small>
        </div>
      </button>
    </div>
    </#if>

    <!-- Kembali ke Sign In -->
    <form action="${url.loginAction}" method="post">
      <input type="hidden" name="mfaMethod" value="BACK"/>
      <button type="submit" class="btn btn-link text-dark d-inline-flex align-items-center gap-1 p-0">
        <i class="ti ti-arrow-left" style="font-size: 14px;"></i>
        Kembali ke Sign In
      </button>
    </form>

    <script>
      function selectMethod(method) {
        document.getElementById('mfaMethod').value = method;
        document.getElementById('mfaSelectForm').submit();
      }
    </script>

  </#if>
</@layout.registrationLayout>
