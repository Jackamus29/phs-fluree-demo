<cfscript>
  function fetchUserByEmail(email) {
    local.userQuery = {
        "where": {
            "@id": "?users",
            "@type": "User",
            "email": email
        },
        "select": { "?users": ["*"] }
    }
    local.userResponse = application.appQuery(userQuery);
    if (isArray(userResponse) and arrayLen(userResponse) > 0) {
        return userResponse[1];
    } 
    return;
  }
</cfscript>

<cfif structKeyExists(form, "submit")>
  <cfset email = form.email>
  <cfset password = form.password>

  <!-- Validate credentials (replace this with your actual authentication logic) -->
  <cfset local.userRecord = fetchUserByEmail(email) />
  <cfif structKeyExists(local, "userRecord") and structKeyExists(local.userRecord, "email") >
      <cfset session.authenticated = true>
      <cfset session.userId = local.userRecord["@id"]>
      <cfset session.email = local.userRecord.email />
      <cfset session.isAdmin = structKeyExists(local.userRecord, "isAdmin") ? local.userRecord.isAdmin : false>
      <cflocation url="../dataentry/participants.cfm" addtoken="false">
  <cfelse>
      <cfset session.authenticated = false>
      <cfset session.email = "">
      <cfset session.isAdmin = false>
      <cfset errorMessage = "User with provided email and password not found. Please try again.">
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
