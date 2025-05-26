<cfoutput>
  <cfdump var="#form#">

  <!--- STUB --->
  <cfif structKeyExists(form, "fieldnames")>
    <cfif form.username EQ "admin" AND form.password EQ "password">
      <cfset session.secret = createUUID()>
      <cfset session.username = form.username>
      <!--- <cflocation url="#local.cleanRequestUrl#"> --->
      <cfdump var="#session#">
    </cfif>
  </cfif>

  <div class="main-wrapper login-wrapper">
    <div id="login">
      <p>Login</p>
      <form id="loginForm" method="post" action="?login=1">
        <input type="hidden" name="type" value="login" disabled=true>
        <div class="form-group">
          <label for="username">Username</label>
          <input type="text" id="username" name="username" required>
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
        <input type="hidden" name="type" value="register" disabled=true>
        <div class="form-group">
          <label for="username">Username</label>
          <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" required>

          <label for="confirmPassword">Confirm Password</label>
          <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <button type="submit">Register</button>
      </form>
</cfoutput>