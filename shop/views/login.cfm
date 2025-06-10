<cfoutput>
  <cfset local.BCrypt = new modules.shop.components.BCrypt()>

  <cfdump var="#form#" expand="false">

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
      <p>Login</p>
      <form id="loginForm" method="post" action="?login=1">
        <input type="hidden" id="registertype" name="type" value="login">
        <div class="form-group">
          <label for="email">Email</label>
          <input type="text" id="email" name="email" required>
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" required>
        </div>
        <button type="submit">Login</button>
      </form>
    </div>

    <div id="register">
      <p>Don't have an account?</p>
      <form id="loginForm" method="post" action="?login=1">
        <input type="hidden" id="logintype" name="type" value="register">
        <div class="form-group">
          <label for="registrationEmail">Email</label>
          <input type="email" id="registrationEmail" name="registrationEmail" required>
        </div>
        <div class="form-group">
          <label for="registrationPassword">Password</label>
          <input type="password" id="registrationPassword" name="registrationPassword" required>

          <label for="confirmRegistrationPassword">Confirm Password</label>
          <input type="password" id="confirmRegistrationPassword" name="confirmRegistrationPassword" required>
        </div>
        <button type="submit">Register</button>
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
            firstname: nullValue(),
            lastname: nullValue(),
            email: form.registrationEmail,
            password: local.hashedPassword,
            active: 1,
            created: now(),
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

      if (!structKeyExists(local, "customer") && !local.BCrypt.checkBCryptHash(form.password, local.customer.getPassword())) {
        throw(type="ValidationError", message="Invalid email or password.");
      }

      session.customer = local.customer;

      // Redirect to the home page or dashboard
      cflocation(url="#local.cleanRequestUrl#");
    }
  </cfscript>
</cfoutput>