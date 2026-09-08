<#import "template.ftl" as layout>

<@layout.registrationLayout title="Logout Confirm"; section>
    <#if section = "form">
        
        <div class="card shadow-sm p-4 text-center" style="max-width:420px;margin:auto;">
            
            <h3 class="mb-3">Logout Confirmation</h3>
            
            <p class="mb-4">
                You are about to sign out from <strong>${realm.displayName!realm.name}</strong>.
            </p>

            <form action="${url.logoutConfirmAction}" method="post">
                
                <div class="d-grid gap-2">
                    <button type="submit" 
                            name="confirmLogout" 
                            value="true"
                            class="btn btn-danger">
                        Yes, Log me out
                    </button>

                    <a href="${url.loginUrl}" 
                       class="btn btn-outline-secondary">
                        Cancel
                    </a>
                </div>

            </form>
        </div>

    </#if>
</@layout.registrationLayout>
