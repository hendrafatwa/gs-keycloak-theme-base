<#import "template.ftl" as layout>

<@layout.registrationLayout title="Microsoft Authenticator"; section>
  <#if section == "form">

    <!-- <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
            style="width: 56px; height: 56px;">
        <i class="ti ti-device-mobile" style="font-size: 28px;"></i>
      </span>
    </div> -->

     <div class="mb-4">
      <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
        <img src="${url.resourcesPath}/assets/img/gs/device-mobile-message.svg" alt="icon" width="24" height="24">
      </span>
    </div>

    <h4 class="mb-1 fw-bold">Microsoft Authenticator</h4>
    <p class="mb-6">Masukkan kode verifikasi 6 digit dari Microsoft Authenticator.</p>

    <form id="totpForm" action="${url.loginAction}" method="post">

      <!-- <div class="mb-6">
        <label class="form-label">Kode Verifikasi</label>
        <div class="auth-input-wrapper d-flex justify-content-between">
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autofocus autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control auth-input h-px-50 text-center otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
        </div>
        <input type="hidden" id="otp" name="otp" />
      </div> -->

      <div class="mb-6">
        <label class="form-label">Kode Verifikasi</label>
        <div class="otp-wrapper">
          <input type="tel" class="form-control otp-input" maxlength="1" autofocus autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
          <input type="tel" class="form-control otp-input" maxlength="1" autocomplete="off" inputmode="numeric" />
        </div>
        <input type="hidden" id="otp" name="otp" />
      </div>

      <!-- <button id="submitBtn" class="btn btn-primary d-grid w-100 mb-4" type="submit">Verify</button> -->
		<button id="submitBtn" class="btn btn-primary d-grid w-100 mb-4" type="submit">
		  <span id="btnText">Verifikasi</span>
		  <span id="btnLoader" style="display:none;">
			<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
			Memverifikasi...
		  </span>
		</button>
    </form>

     <!-- Kembali ke pilihan MFA -->
      <form action="${url.loginAction}" method="post" class="mt-6">
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
    (function () {
      const inputs = document.querySelectorAll('.otp-input');
      const hiddenOtp = document.getElementById('otp');
      const form = document.getElementById('totpForm');
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

      setTimeout(() => inputs[0].focus(), 100);
    })();
    </script>
  </#if>
</@layout.registrationLayout>