<#import "template.ftl" as layout>
<#assign isUpdatePasswordPage = true>

<@layout.registrationLayout displayMessage=false title="Update Password"; section>
  <#if section == "form">
    <h4 class="mb-1">Update Password</h4>
    <p class="mb-6">Please set your new password.</p>

    <!-- Password Requirements Info Box -->
    <div class="alert alert-danger mb-4" role="alert">
      <#if message?has_content>
        <div class="d-flex align-items-start mb-2 text-warning" style="font-size: .875rem;">
          <i class="ti ti-alert-circle me-1" style="margin-top: 2px;"></i>
          <div>${kcSanitize(message.summary)?no_esc}</div>
        </div>
      </#if>

      <h6 class="alert-heading mb-2"><i class="ti ti-info-circle me-1"></i>Password Requirements:</h6>
      <ul class="mb-0 password-requirements" style="padding-left: 0; font-size: 0.875rem; list-style: none;">
        <li id="req-length" data-met="false">
          <span class="req-icon"></span>
          <span class="req-text">Minimum <strong>8 characters</strong></span>
        </li>
        <li id="req-uppercase" data-met="false">
          <span class="req-icon"></span>
          <span class="req-text">At least <strong>1 uppercase letter</strong> (A-Z)</span>
        </li>
        <li id="req-special" data-met="false">
          <span class="req-icon"></span>
          <span class="req-text">At least <strong>1 special character</strong> (!@#$%^&*)</span>
        </li>
        <li id="req-number" data-met="false">
          <span class="req-icon"></span>
          <span class="req-text">At least <strong>1 number</strong> (0-9)</span>
        </li>
      </ul>
    </div>

    <form id="kc-update-password-form" class="mb-6" action="${url.loginAction}" method="post">
      <!-- New Password -->
      <div class="mb-4 form-password-toggle">
        <label for="password-new" class="form-label">New Password</label>
        <div class="input-group input-group-merge">
          <input type="password" 
                 class="form-control ${messagesPerField.existsError('password','password-confirm')?then('is-invalid','')}" 
                 id="password-new" 
                 name="password-new"
                 placeholder="••••••••••••" 
                 autocomplete="new-password"
                 autofocus
                 required />
          <span class="input-group-text cursor-pointer" id="togglePasswordNew">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
        
        <!-- Password Strength Indicator -->
        <div class="mt-2">
          <div class="progress" style="height: 4px;">
            <div id="password-strength-bar" class="progress-bar" role="progressbar" style="width: 0%"></div>
          </div>
          <small id="password-strength-text" class="text-muted"></small>
        </div>
      </div>

      <!-- Confirm Password -->
      <div class="mb-6 form-password-toggle">
        <label for="password-confirm" class="form-label">Confirm Password</label>
        <div class="input-group input-group-merge">
          <input type="password" 
                 class="form-control ${messagesPerField.existsError('password-confirm')?then('is-invalid','')}" 
                 id="password-confirm" 
                 name="password-confirm"
                 placeholder="••••••••••••" 
                 autocomplete="new-password"
                 required />
          <span class="input-group-text cursor-pointer" id="togglePasswordConfirm">
            <i class="ti ti-eye-off"></i>
          </span>
        </div>
        <div id="password-match-feedback" class="mt-1"></div>
      </div>

      <div class="d-grid gap-2">
        <button class="btn btn-primary" type="submit" id="submitBtn">
          Update Password
        </button>
        
        <#if isAppInitiatedAction??>
          <a href="${url.loginAction}" class="btn btn-outline-secondary">
            <i class="ti ti-arrow-left me-1"></i>Skip for now
          </a>
        </#if>
      </div>
    </form>

    <style>
      .password-requirements li {
        margin-bottom: 0.25rem;  
        line-height: 1.2;         
        transition: all 0.3s ease;
        display: flex;
        align-items: flex-start;
      }

      .password-requirements .req-icon {
        display: inline-block;
        width: 14px;              
        margin-right: 6px;       
        font-weight: 700;
        line-height: 1.2;
        flex: 0 0 14px;
      }

      .password-requirements [data-met="false"] .req-icon {
        color: #6c757d;
      }

      .password-requirements [data-met="false"] .req-text {
        color: inherit;
      }

      .password-requirements [data-met="true"] .req-icon {
        color: #28a745;
      }

      .password-requirements [data-met="true"] .req-text {
        color: #28a745;
      }

      .password-requirements [data-met="true"] .req-icon::before {
        content: "✓";
      }

      .password-requirements [data-met="false"] .req-icon::before {
        content: "○";
      }
    </style>

    <script>
      (function() {
        // Toggle password visibility
        function setupPasswordToggle(buttonId, inputId) {
          var btn = document.getElementById(buttonId);
          var input = document.getElementById(inputId);
          if (!btn || !input) return;

          btn.addEventListener('click', function() {
            var isPwd = input.getAttribute('type') === 'password';
            input.setAttribute('type', isPwd ? 'text' : 'password');
            var icon = btn.querySelector('i');
            if (icon) {
              icon.classList.toggle('ti-eye-off', !isPwd);
              icon.classList.toggle('ti-eye', isPwd);
            }
          });
        }

        setupPasswordToggle('togglePasswordNew', 'password-new');
        setupPasswordToggle('togglePasswordConfirm', 'password-confirm');

        // Password validation
        var passwordInput = document.getElementById('password-new');
        var confirmInput = document.getElementById('password-confirm');
        var strengthBar = document.getElementById('password-strength-bar');
        var strengthText = document.getElementById('password-strength-text');
        var matchFeedback = document.getElementById('password-match-feedback');

        // Requirements configuration
        var requirements = {
          length: { 
            test: function(pw) { return pw.length >= 8; }, 
            el: 'req-length'
          },
          uppercase: { 
            test: function(pw) { return /[A-Z]/.test(pw); }, 
            el: 'req-uppercase'
          },
          special: { 
            test: function(pw) { return /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(pw); }, 
            el: 'req-special'
          },
          number: { 
            test: function(pw) { return /[0-9]/.test(pw); }, 
            el: 'req-number'
          }
        };

        function validatePassword() {
          var password = passwordInput.value;
          var strength = 0;
          var metRequirements = 0;

          // Check each requirement
          for (var key in requirements) {
            var req = requirements[key];
            var met = req.test(password);
            var element = document.getElementById(req.el);
            
            if (element) {
              if (met) {
                strength += 25;
                metRequirements++;
                element.setAttribute('data-met', 'true');
              } else {
                element.setAttribute('data-met', 'false');
              }
            }
          }

          // Update strength bar
          strengthBar.style.width = strength + '%';
          
          if (strength === 0 || password.length === 0) {
            strengthBar.className = 'progress-bar';
            strengthText.textContent = '';
          } else if (strength < 50) {
            strengthBar.className = 'progress-bar bg-danger';
            strengthText.textContent = 'Weak';
            strengthText.className = 'text-danger small';
          } else if (strength < 100) {
            strengthBar.className = 'progress-bar bg-warning';
            strengthText.textContent = 'Medium';
            strengthText.className = 'text-warning small';
          } else {
            strengthBar.className = 'progress-bar bg-success';
            strengthText.textContent = 'Strong';
            strengthText.className = 'text-success small';
          }

          return metRequirements === 4;
        }

        function checkPasswordMatch() {
          var password = passwordInput.value;
          var confirm = confirmInput.value;

          if (confirm.length === 0) {
            matchFeedback.textContent = '';
            confirmInput.classList.remove('is-invalid');
            confirmInput.classList.remove('is-valid');
            return true;
          }

          if (password === confirm) {
            matchFeedback.innerHTML = '<small class="text-success"><i class="ti ti-check me-1"></i>Passwords match</small>';
            confirmInput.classList.remove('is-invalid');
            confirmInput.classList.add('is-valid');
            return true;
          } else {
            matchFeedback.innerHTML = '<small class="text-danger"><i class="ti ti-x me-1"></i>Passwords do not match</small>';
            confirmInput.classList.add('is-invalid');
            confirmInput.classList.remove('is-valid');
            return false;
          }
        }

        // Event listeners
        if (passwordInput) {
          passwordInput.addEventListener('input', function() {
            passwordInput.classList.remove('is-invalid');
            validatePassword();
            if (confirmInput && confirmInput.value) {
              checkPasswordMatch();
            }
          });

          passwordInput.addEventListener('keyup', validatePassword);
        }

        if (confirmInput) {
          confirmInput.addEventListener('input', function() {
            confirmInput.classList.remove('is-invalid');
            checkPasswordMatch();
          });

          confirmInput.addEventListener('keyup', checkPasswordMatch);
        }

        // Form validation on submit
        var form = document.getElementById('kc-update-password-form');
        if (form) {
          form.addEventListener('submit', function(e) {
            var isValid = validatePassword();
            var isMatch = checkPasswordMatch();

            if (!isValid || !isMatch) {
              e.preventDefault();
              
              if (!isValid) {
                passwordInput.classList.add('is-invalid');
              }
              
              if (!isMatch) {
                confirmInput.classList.add('is-invalid');
              }

              // Scroll to top to show requirements
              window.scrollTo({ top: 0, behavior: 'smooth' });
            }
          });
        }

        // Initial validation if there's a value (e.g., after error)
        if (passwordInput && passwordInput.value) {
          validatePassword();
        }
      })();
    </script>
  </#if>
</@layout.registrationLayout>