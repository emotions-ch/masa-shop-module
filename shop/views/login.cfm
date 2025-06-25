<cfoutput>
  <cfset local.BCrypt = new modules.shop.components.BCrypt()>

  <!--- STUB --->
  <!--- <cfif structKeyExists(form, "fieldnames")>
    <cfif form["email"] EQ "admin" AND form.password EQ "password">
      <cfset session.secret = createUUID()>
      <cfset session.email = form.email>
      <!--- <cflocation url="#local.cleanRequestUrl#"> --->
      <cfdump var="#session#">
    </cfif>
  </cfif> --->

  <div class="main-wrapper login-wrapper">
    <div id="login">
      <cfif (structKeyExists(url, "error") AND url.error EQ "invalid_credentials")>
        <p class="error">Invalid email or password. Please try again.</p>
      </cfif>

      <h2>Login</h2>
      <form id="loginForm" method="post" action="?login=1">
        <input class="form-control" type="hidden" id="registertype" name="type" value="login">
        <div class="form-group">
          <label for="email">Email</label>
          <input class="form-control" type="text" id="email" name="email" required value="meow+testing@emotions.ch">
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input class="form-control" type="password" id="password" name="password" required value="meowpassword69">
        </div>
        <button class="btn btn-primary" type="submit">Login</button>
      </form>
    </div>

    <div id="register">
      <h2>Don't have an account?</h2>
      <form id="loginForm" method="post" action="?login=1">
        <input class="form-control" type="hidden" id="logintype" name="type" value="register">
        <div class="form-group">
          <label for="registrationFirstname">First Name</label>
          <input class="form-control" type="text" id="registrationFirstname" name="registrationFirstname" required>
        </div>
        <div class="form-group">
          <label for="registrationLastname">Last Name</label>
          <input class="form-control" type="text" id="registrationLastname" name="registrationLastname" required>
        </div>
        <div class="form-group">
          <label for="registrationEmail">Email</label>
          <input class="form-control" type="email" id="registrationEmail" name="registrationEmail" required>
        </div>
        <div class="form-group">
          <label for="registrationPassword">Password</label>
          <input class="form-control" type="password" id="registrationPassword" name="registrationPassword" required>

          <label for="confirmRegistrationPassword">Confirm Password</label>
          <input class="form-control" type="password" id="confirmRegistrationPassword" name="confirmRegistrationPassword" required>
        </div>
        <button class="btn btn-primary" type="submit">Register</button>
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
        writeDump(entityLoad("customer", {email=form.registrationEmail}));
        abort;

      } else {
        var local.hashedPassword = local.BCrypt.toBCryptHash(form.registrationPassword);
        writeDump(var="#local.hashedPassword#", label="Hashed Password");

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
      // Handle login logic here
      if (form.email EQ "" OR form.password EQ "") {
        throw(type="ValidationError", message="Email and password are required.");
      }

      local.customer = entityLoad("customer", {email=form.email})[1];

      // writeDump(var="#local.BCrypt.checkBCryptHash(form.password, local.customer.getPassword())#", abort=true);

      if (!local.BCrypt.checkBCryptHash(form.password, local.customer.getPassword())) {
        cflocation(url="#local.cleanRequestUrl#?login=1&error=invalid_credentials");
      } else {
        session.customer = local.customer;

        // Redirect to the home page or dashboard
        cflocation(url="#local.cleanRequestUrl#");
      }
    }
  </cfscript>
</cfoutput>