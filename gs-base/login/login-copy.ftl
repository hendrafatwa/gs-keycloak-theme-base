<#import "template.ftl" as layout>
<#assign pageTitle = "Login">

<@layout.registrationLayout; section>
  <#if section == "form">
    <h4 class="mb-1 fw-bold">GS SMART</h4>
    <p class="mb-6">Welcome! Please sign in to continue.</p>

    <form id="formAuthentication" class="mb-6" action="${url.loginAction}" method="post">
      <div class="mb-6">
        <label for="username" class="form-label">Username</label>
        <input type="text"
               class="form-control"
               id="username"
               name="username"
               value="${(login.username!'')}"
               placeholder="Enter your username"
               autofocus
               autocomplete="username" />
      </div>

      <div class="mb-6 form-password-toggle">
        <label class="form-label" for="password">Password</label>
        <div class="input-group input-group-merge">
          <input type="password"
                 id="password"
                 class="form-control"
                 name="password"
                 placeholder="&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;&#xb7;"
                 autocomplete="current-password"
                 aria-describedby="password" />
          <span class="input-group-text cursor-pointer" id="togglePassword">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
      </div>

      <#-- Remember Me (kalau diaktifkan di realm) -->
      <#if realm.rememberMe?? && realm.rememberMe>
        <div class="my-4">
          <div class="form-check">
            <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe"
                   <#if login.rememberMe?? && login.rememberMe>checked</#if>>
            <label class="form-check-label" for="rememberMe">Remember me</label>
          </div>
        </div>
      </#if>

      <div class="my-8">
        <div class="d-flex justify-content-end">
          <#if realm.resetPasswordAllowed?? && realm.resetPasswordAllowed>
            <a href="${url.loginResetCredentialsUrl}">
              <p class="mb-0">Forgot Password?</p>
            </a>
          </#if>
        </div>
      </div>

      <#-- kalau ada credentialId -->
      <#assign credId = (auth.selectedCredential)!''>
      <#if credId?has_content>
        <input type="hidden" name="credentialId" value="${credId}" />
      </#if>

      <button class="btn btn-primary d-grid w-100" type="submit">Sign in</button>
    </form>

    <#-- Optional: link register (kalau enable) -->
    <#if realm.registrationAllowed?? && realm.registrationAllowed>
      <p class="text-center">
        <span>Don’t have an account?</span>
        <a href="${url.registrationUrl}"><span>Sign up</span></a>
      </p>
    </#if>

    <script>
      // Toggle show/hide password (pakai icon tabler sesuai template kamu)
      (function () {
        var btn = document.getElementById('togglePassword');
        var input = document.getElementById('password');
        if (!btn || !input) return;

        btn.addEventListener('click', function () {
          var isPwd = input.getAttribute('type') === 'password';
          input.setAttribute('type', isPwd ? 'text' : 'password');
          var icon = btn.querySelector('i');
          if (icon) {
            icon.classList.toggle('ti-eye-off', !isPwd);
            icon.classList.toggle('ti-eye', isPwd);
          }
        });
      })();
    </script>
  </#if>
</@layout.registrationLayout>
