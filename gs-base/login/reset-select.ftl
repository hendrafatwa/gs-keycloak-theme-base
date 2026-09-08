<#import "template.ftl" as layout>

<#-- Mode vendor: RFID tidak ditawarkan karena vendor bukan karyawan dan
     tidak memegang kartu identitas. -->
<#assign isVendor = vendorMode!false>

<@layout.registrationLayout title="Verifikasi Akun"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-fingerprint" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Verifikasi Akun</h4>
    <p class="mb-6">
      <#if isVendor>
        Masukkan password lama Anda untuk melanjutkan.
      <#else>
        Pilih metode verifikasi untuk melanjutkan.
      </#if>
    </p>

    <form id="selectForm" action="${url.loginAction}" method="post">
      <input type="hidden" name="rpAction" id="rpAction" value="" />
    </form>

    <!-- Password Lama -->
    <div class="<#if isVendor>mb-6<#else>mb-3</#if>">
      <button type="button"
              class="btn btn-outline-secondary w-100 py-4 text-center"
              onclick="pilih('PASSWORD')"
              style="border-color: #ccc;">
        <div class="d-flex flex-column align-items-center gap-2">
          <img src="${url.resourcesPath}/assets/img/gs/asterisk.svg" alt="icon" width="24" height="24">
          <div class="fw-semibold">Password Lama</div>
          <small class="text-muted">Masukkan password lama Anda</small>
        </div>
      </button>
    </div>

    <#if !isVendor>
    <!-- Kartu RFID -->
    <div class="mb-6">
      <button type="button"
              class="btn btn-outline-secondary w-100 py-4 text-center"
              onclick="pilih('RFID')"
              style="border-color: #ccc;">
        <div class="d-flex flex-column align-items-center gap-2">
          <img src="${url.resourcesPath}/assets/img/gs/id.svg" alt="icon" width="24" height="24">
          <div class="fw-semibold">Kartu RFID</div>
          <small class="text-muted">Tempelkan kartu identitas karyawan Anda pada reader</small>
        </div>
      </button>
    </div>
    </#if>

    <!-- Kembali -->
    <form action="${url.loginAction}" method="post">
      <input type="hidden" name="rpAction" value="BACK_NPK" />
      <button type="submit" class="btn btn-link text-dark small p-0">
        <i class="ti ti-arrow-left me-1"></i>Kembali
      </button>
    </form>

    <script>
      function pilih(metode) {
        document.getElementById('rpAction').value = metode;
        document.getElementById('selectForm').submit();
      }
    </script>

  </#if>
</@layout.registrationLayout>
