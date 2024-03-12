<cfset request.cancelLink = "/app/pages/admin/dashboard.cfm"/>

<!--- Empty User record --->
<cfset request.user = {
  "firstName": "",
  "lastName": "",
  "email": "",
  "isAdmin": false
} />

<!--- If submitting Add User form, Transact User --->
<cfif structKeyExists(form, "submit")>
  <cfset transaction = {
    "insert": {
      "@id": "users/#listToArray(form.email, "@")[1]#",
      "@type": "User",
      "firstName": form.firstName,
      "lastName": form.lastName,
      "email": form.email,
      "isAdmin": form.isAdmin,
      "clinic": { "@id": form.clinic }
    }
  } />
  <cfset variables.success = application.userTransaction(transaction) />
  <cfif variables.success>
    <cflocation url="#request.cancelLink#" addtoken="false"/>
  </cfif>
</cfif>

<!DOCTYPE html>
<html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      
      <title>New User</title>
      <link rel="stylesheet" href="/app/styles/main.css"/>
      <link rel="stylesheet" href="/app/styles/dashboard.css"/>
  </head>
  <body>
      <cfinclude template="/app/templates/navbar.cfm">
      <div class="container">
          <h2>Add User</h2>
          <cfif structKeyExists(variables, "success") and !variables.success>
            <p style="color: red;">Error adding new user.</p>
          </cfif>
          <cfinclude template="/app/templates/forms/user-form.cfm"/>
      </div>

  </body>
</html>
