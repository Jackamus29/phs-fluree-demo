<cfset request.cancelLink = "/app/pages/dataentry/participants.cfm"/>

<!--- Empty Participant record --->
<cfset request.ppt = {
  "firstName": "",
  "lastName": "",
  "dob": ""
} />

<!--- If submitting Add User form, Transact User --->
<cfif structKeyExists(form, "submit")>
  <cfset local.maxPidResult = application.appQuery({
    "where": { "pid": "?pids" },
    "select": [ "(max ?pids)"]
  }) />
  <!--- The javaCast is needed because otherwise CF will add ".0" to the end of the integer when using serializeJSON --->
  <cfset local.nextPid = javaCast("int", local.maxPidResult[1][1] + 1) />
  <cfset transaction = {
    "insert": {
      "@id": "ppts/#local.nextPid#",
      "@type": "Participant",
      "pid": local.nextPid,
      "firstName": form.firstName,
      "lastName": form.lastName,
      "dob": form.dob,
      "clinic": { "@id": form.clinic }
    }
  } />
  <cfset variables.success = application.userTransaction(transaction) />
  <cflog text="add participant tx: #serializeJSON(transaction)#" />
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
          <cfinclude template="/app/templates/forms/ppt-form.cfm"/>
      </div>
  </body>
</html>
