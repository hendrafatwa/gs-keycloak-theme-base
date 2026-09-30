<#import "template.ftl" as layout>

<#-- Mode vendor: RFID tidak ditawarkan karena vendor bukan karyawan dan
     tidak memegang kartu identitas. -->
<#assign isVendor = vendorMode!false>

<#-- Verifikasi langsung lewat WhatsApp: untuk user yang lupa password dan
     tidak berada di kantor. Hanya muncul kalau diaktifkan per realm DAN
     nomor WhatsApp user terdaftar. -->
<#assign waAda = waAvailable!false>

<#-- Card terakhir yang tampil butuh jarak lebih besar. Urutannya:
     WhatsApp (kalau ada) > RFID (kalau bukan vendor) > Password Lama. -->
<#assign akhirPassword = isVendor && !waAda>
<#assign akhirRfid     = !isVendor && !waAda>

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
      <#if isVendor && !waAda>
        Masukkan password lama Anda untuk melanjutkan.
      <#else>
        Pilih metode verifikasi untuk melanjutkan.
      </#if>
    </p>

    <form id="selectForm" action="${url.loginAction}" method="post">
      <input type="hidden" name="rpAction" id="rpAction" value="" />
    </form>

    <!-- Password Lama -->
    <div class="<#if akhirPassword>mb-6<#else>mb-3</#if>">
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
    <div class="<#if akhirRfid>mb-6<#else>mb-3</#if>">
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

    <#if waAda>
    <!-- WhatsApp -->
    <div class="mb-6">
      <button type="button"
              class="btn btn-outline-secondary w-100 py-4 text-center"
              onclick="pilih('WA')"
              style="border-color: #ccc;">
        <div class="d-flex flex-column align-items-center gap-2">
          <i class="ti ti-brand-whatsapp" style="font-size: 24px;"></i>
          <div class="fw-semibold">WhatsApp</div>
          <small class="text-muted">Kirim pesan ke WhatsApp kami untuk menerima kode verifikasi</small>
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
