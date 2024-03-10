<cfset request.cancelLink = "/app/pages/admin/dashboard.cfm"/>

<cfif structKeyExists(url, "userid") and url.userid != "">
  <cfset userRecord = application.userQuery({
    "selectOne": { "#url.userid#": ["*"] }
  })>
<cfelse>
  <cflocation url="#request.cancelLink#" addtoken="false"/>
</cfif>

<cfset request.user = userRecord />

<cfif structKeyExists(form, "submit")>
  <cfset transaction = {
    "where": {
      "@id": userRecord["@id"],
      "firstName": "?firstName",
      "lastName": "?lastName",
      "email": "?email",
      "isAdmin": "?isAdmin"
    },
    "delete": {
      "@id": userRecord["@id"],
      "firstName": "?firstName",
      "lastName": "?lastName",
      "email": "?email",
      "isAdmin": "?isAdmin"
    },
    "insert": {
      "@id": form["@id"],
      "firstName": form.firstName,
      "lastName": form.lastName,
      "email": form.email,
      "isAdmin": form.isAdmin
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
    
    <title>Edit User</title>
    <link rel="stylesheet" href="/app/styles/main.css"/>
    <link rel="stylesheet" href="/app/styles/dashboard.css"/>
</head>
<body>
    <cfinclude template="/app/templates/navbar.cfm">
    <div class="container">
      <h2>Edit User</h2>
      <cfif structKeyExists(variables, "success") and !variables.success>
        <p style="color: red;">Error saving user details.</p>
      </cfif>
      <cfinclude template="/app/templates/forms/user-form.cfm"/>
    </div>

</body>
</html>