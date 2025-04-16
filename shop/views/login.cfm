<cfoutput>
  <cfdump var="#form#">

  <!--- STUB --->
  <cfif structKeyExists(form, "fieldnames")>
    <cfif form.username EQ "admin" AND form.password EQ "password">
      <cfset session.isLoggedIn = true>
      <cfset session.username = form.username>
      <cflocation url="#local.cleanRequestUrl#">
    </cfif>
  </cfif>

  <div class="main-wrapper">
    <form id="loginForm" method="post" action="?login=1">
      <div class="form-group">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" required>
      </div>
      <div class="form-group">
        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>
      </div>
      <button type="submit">Login</button>
  </div>
</cfoutput>