<#import "template.ftl" as layout>

<@layout.registrationLayout title="Verifikasi Tidak Tersedia"; section>
  <#if section == "form">

    <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <i class="ti ti-alert-triangle" style="font-size: 28px;"></i>
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Verifikasi Tidak Dapat Dilakukan</h4>
    <p class="mb-6">
      Akun Anda belum dapat melewati tahap verifikasi. Silakan hubungi IT
      untuk melengkapi data akun Anda.
    </p>

    <form action="${url.loginAction}" method="post">
      <input type="hidden" name="mfaMethod" value="BACK" />
      <button type="submit" class="btn btn-primary d-grid w-100">
        <i class="ti ti-arrow-left me-1"></i>Kembali ke Sign In
      </button>
    </form>

  </#if>
</@layout.registrationLayout>
