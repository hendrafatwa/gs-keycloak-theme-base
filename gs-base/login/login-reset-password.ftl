<#import "template.ftl" as layout>

<@layout.registrationLayout title="Forgot Password"; section>
  <#if section == "form">
  
    <div class="mb-4">
    <span class="d-inline-flex align-items-center justify-content-center rounded-3 border"
          style="width: 56px; height: 56px;">
      <i class="ti ti-fingerprint" style="font-size: 28px;"></i>
    </span>
  </div>

    <h4 class="mb-1">Forgot your Password?</h4>
    <p class="mb-6">Enter your username and we'll send you instructions to reset your password.</p>

    <form id="kc-reset-password-form" class="mb-6" action="${url.loginAction}" method="post">
      <div class="mb-6">
        <label for="username" class="form-label">Username</label>
        <input type="text"
               class="form-control"
               id="username"
               name="username"
               value="${(auth.attemptedUsername!'')}"
               placeholder="Enter your username"
               autofocus />
      </div>

      <button class="btn btn-primary d-grid w-100" type="submit">Send reset link</button>
    </form>

    <p class="text-center">
      <a href="${url.loginUrl}" class="d-inline-flex text-dark align-items-center gap-1">
        <i class="ti ti-arrow-left"></i>
        Back to sign in
      </a>
    </p>

  </#if>
</@layout.registrationLayout>
