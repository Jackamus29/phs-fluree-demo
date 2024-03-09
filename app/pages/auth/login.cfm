<cfscript>
  cflog(text="on login.cfm page!");
  function isValidUser(username, password) {
    // fluree query to check users
    return true;
  }
</cfscript>

<cfif structKeyExists(form, "submit")>
  <cflog text="form submitted!" />
  <cfset email = form.email>
  <cfset password = form.password>

  <cflog text="#serializeJSON(form)#" />

  <!-- Validate credentials (replace this with your actual authentication logic) -->
  <cfif isValidUser(email, password)>
      <cfset session.authenticated = true>
      <cfset session.email = email>
      <cflocation url="../dataentry/demographics.cfm" addtoken="no">
  <cfelse>
      <cfset errorMessage = "Invalid credentials. Please try again.">
  </cfif>
</cfif>

<!-- Display login form and error message -->
<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Login Form</title>
      <link rel="stylesheet" href="/app/styles/login.css">
  </head>
  <body>
      <div class="login-container">
          <h2>Login</h2>
          <cfif structKeyExists(variables, "errorMessage")>
              <p style="color: red;">#variables.errorMessage#</p>
          </cfif>
          <form class="login-form" method="post">
              <div class="form-group">
                  <label for="email">Email:</label>
                  <input type="email" id="email" name="email" value="#session.email ?: ''#" required>
              </div>
              <div class="form-group">
                  <label for="password">Password:</label>
                  <input type="password" id="password" name="password" required>
              </div>
              <div class="form-group">
                  <button name="submit" type="submit">Login</button>
              </div>
          </form>
      </div>
  </body>
  </html>

</cfoutput>
