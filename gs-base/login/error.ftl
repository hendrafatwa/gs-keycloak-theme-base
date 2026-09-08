<#import "template.ftl" as layout>

<@layout.registrationLayout title="Error"; section>
  <#if section == "form">
    <h4 class="mb-1">Something went wrong</h4>
    <p class="mb-6">
      <#if message?has_content>
        ${message.summary?no_esc}
      <#else>
        An unexpected error occurred.
      </#if>
    </p>

    <#--
      Gunakan client.baseUrl jika tersedia (paling reliable).
      Fallback ke url.loginRestartFlowUrl untuk restart flow.
      Fallback terakhir ke realm login page langsung.
    -->
    <#if client?has_content && client.baseUrl?has_content>
      <#assign backUrl = client.baseUrl>
    <#elseif url.loginRestartFlowUrl?has_content>
      <#assign backUrl = url.loginRestartFlowUrl>
    <#else>
      <#assign backUrl = "/realms/" + realm.name + "/protocol/openid-connect/auth">
    </#if>

    <a class="btn btn-primary d-grid w-100" href="${backUrl}">
      <i class="ti ti-arrow-left me-1"></i>Back to login
    </a>
  </#if>
</@layout.registrationLayout>
