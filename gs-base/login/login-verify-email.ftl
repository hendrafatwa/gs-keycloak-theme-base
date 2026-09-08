<#import "template.ftl" as layout>

<@layout.registrationLayout title="Verify Email"; section>
  <#if section == "form">
    <h4 class="mb-1">Verify your email</h4>
    <p class="mb-6">
      We’ve sent a verification link to your email. Please check your inbox and follow the instructions.
    </p>

    <div class="d-grid gap-2">
      <a class="btn btn-primary" href="${url.loginAction}">Continue</a>
      <a class="btn btn-outline-secondary" href="${url.loginUrl}">Back to login</a>
    </div>
  </#if>
</@layout.registrationLayout>
