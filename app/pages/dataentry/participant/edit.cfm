<cfset request.cancelLink = "/app/pages/dataentry/participants.cfm"/>

<!--- Query Participant Details for Edit Form --->
<cfif structKeyExists(url, "pid") and url.pid != "">
  <!--- The javaCast is needed because otherwise CF will add ".0" to the end of the integer when using serializeJSON --->
  <cfset local.pidFromUrl = javaCast("int", lsParseNumber(url.pid)) />
  <cfset pptRecord = application.userQuery({
    "@context": {
      "clinic": { "@reverse": "participants" }
    },
    "where": { 
      "@id": "?ppt",
      "pid": local.pidFromUrl
    },
    "select": { "?ppt": ["*", {"clinic": ["@id", "name"]}] }
  })>
<cfelse>
  <cflocation url="#request.cancelLink#" addtoken="false"/>
</cfif>

<cfset request.ppt = pptRecord[1] />

<!--- If submitting Edit User form, Transact Participant --->
<cfif structKeyExists(form, "submit")>
  <cfset transaction = [{
    "where": {
      "@id": request.ppt["@id"],
      "firstName": "?firstName",
      "lastName": "?lastName",
      "dob": "?dob"
    },
    "delete": {
      "@id": request.ppt["@id"],
      "firstName": "?firstName",
      "lastName": "?lastName",
      "dob": "?dob"
    },
    "insert": {
      "@id": request.ppt["@id"],
      "firstName": form.firstName,
      "lastName": form.lastName,
      "dob": form.dob
    }
  }] />
  <!---  If the Clinic has changed, that data needs to be updated on the Clinic entity, not the Participant  --->
  <cfif form.clinic != request.ppt.clinic["@id"]>
    <cfset clinicUpdateAdded = arrayAppend(transaction, {
      "where": {
        "@id": request.ppt.clinic["@id"],
        "participants": request.ppt["@id"]
      },
      "delete": {
        "@id": request.ppt.clinic["@id"],
        "participants": request.ppt["@id"]
      },
      "insert": {
        "@id": form.clinic,
        "participants": request.ppt["@id"]
      }
    }) />
  </cfif>
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
        <h2>Edit Participant</h2>
        <cfif structKeyExists(variables, "success") and !variables.success>
          <p style="color: red;">Error saving participant details.</p>
        </cfif>
        <cfinclude template="/app/templates/forms/ppt-form.cfm"/>
      </div>

  </body>
</html>
