<cfoutput>
  <cfset local.BCrypt = new modules.shop.components.BCrypt()>
  <nav aria-label="breadcrumb">
    <div class="breadcrumb mt-3 flex-column flex-sm-row">
      <div class="ml-sm-auto">
        <a class="btn btn-primary" href="#local.cleanRequestUrl#"><i class="fas fa-arrow-left"></i> Zurück zum Shop</a>
      </div>
    </div>
  </nav>
 
  <div class="main-wrapper login-wrapper">
    <div id="login">
      <cfif (structKeyExists(url, "error") AND url.error EQ "invalid_credentials")>
        <p class="error">Ihre Login angaben sind nicht korrekt.</p>
      </cfif>

      <h2>Login</h2>
      <form id="loginForm" method="post" action="?login=1">
        <input class="form-control" type="hidden" id="registertype" name="type" value="login">
        <div class="form-group">
          <label for="email">Email</label>
          <input class="form-control" type="text" id="email" name="email" required>
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input class="form-control" type="password" id="password" name="password" required>
        </div>
        <button class="btn btn-primary" type="submit"><i class="fas fa-sign-in-alt"></i> Login</button>
      </form>
    </div>

    <div id="register">
      <h2>Noch keinen Account bei uns?</h2>
      <form id="loginForm" method="post" action="?login=1">
        <input class="form-control" type="hidden" id="logintype" name="type" value="register">
        <div class="form-group">
          <label for="registrationFirstname">Vorname</label>
          <input class="form-control" type="text" id="registrationFirstname" name="registrationFirstname" required>
        </div>
        <div class="form-group">
          <label for="registrationLastname">Nachname</label>
          <input class="form-control" type="text" id="registrationLastname" name="registrationLastname" required>
        </div>
        <div class="form-group">
          <label for="registrationEmail">Email</label>
          <input class="form-control" type="email" id="registrationEmail" name="registrationEmail" required>
        </div>
        <div class="form-group">
          <label for="registrationPassword">Passwort</label>
          <input class="form-control" type="password" id="registrationPassword" name="registrationPassword" required>

          <label for="confirmRegistrationPassword">Passwort wiederholen</label>
          <input class="form-control" type="password" id="confirmRegistrationPassword" name="confirmRegistrationPassword" required>
        </div>

        <button class="btn btn-primary" type="submit"><i class="fas fa-user-plus"></i> Registrieren</button>
      </form>
    </div>
  </div>

  <script>
    document.addEventListener('DOMContentLoaded', function() {
      // Get the registration form
      const registerForm = document.querySelector('##register form');
      
      registerForm.addEventListener('submit', function(event) {
        // Get password fields
        const password = document.getElementById('registrationPassword');
        const confirmPassword = document.getElementById('confirmRegistrationPassword');
        
        // Check if passwords match
        if (password.value !== confirmPassword.value) {
          // Prevent form submission
          event.preventDefault();
          // Alert the user
          alert('Passwords do not match!');
        }
      });
    });
  </script>

  <cfscript>
    if (structKeyExists(form, "type") AND form.type EQ "register") {
      // Handle registration logic here
      if (form.registrationPassword NEQ form.confirmRegistrationPassword) {
        // Passwords do not match
        throw(type="ValidationError", message="Passwords do not match.");

      } else if (entityLoad("customer", {email=form.registrationEmail}).len() ) {
        abort;

      } else {
        var local.hashedPassword = local.BCrypt.toBCryptHash(form.registrationPassword);

        local.customer = entityNew("customer",
          {
            firstname: form.registrationFirstname,
            lastname: form.registrationLastname,
            email: form.registrationEmail,
            password: local.hashedPassword,
            active: 1,
            created: now(),
            passwordCreated: now(),
            lastLogin: now(),
            lastUpdate: now()
          }
        );

        entitySave(local.customer, true);
        ormFlush();
        session.customer = entityLoad("customer", {email=form.registrationEmail})[1]
      }

      // Redirect to the home page or dashboard
      cflocation(url="#local.cleanRequestUrl#");
    } else if (structKeyExists(form, "type") AND form.type EQ "login") {
      if (form.email EQ "" OR form.password EQ "") {
        throw(type="ValidationError", message="Email and password are required.");
      }

      local.customer = entityLoad("customer", {email=form.email});
      if (local.customer.len() == 0 || !local.BCrypt.checkBCryptHash(form.password, local.customer[1].getPassword())) {
        cflocation(url="#local.cleanRequestUrl#?login=1&error=invalid_credentials");
      } else {
        session.customer = local.customer[1];
			
        // Redirect to the home page or dashboard
        cflocation(url="#local.cleanRequestUrl#");
      }
    }
  </cfscript>
</cfoutput>
