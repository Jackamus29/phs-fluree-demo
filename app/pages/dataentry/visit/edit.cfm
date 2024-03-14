<cfset request.cancelLink = "/app/pages/dataentry/participants.cfm"/>

<!--- Query Clinic Visit details --->
<cfif structKeyExists(url, "visitId") and url.visitId != "">
  <cfset local.visitQuery = {
    "select": { "#url.visitId#": ["*"] }
  }/>
  <cfif structKeyExists(url, "t")>
    <cfset local.tValue = javaCast("int", lsParseNumber(url.t)) />
    <cfset local.visitQuery["t"] = local.tValue />
  </cfif>
  <cfset request.visitRecordResult = application.userQuery(local.visitQuery) />
  <cflog text="local.visitQuery: #serializeJSON(local.visitQuery)#" />
  <cflog text="request.visitRecordResult: #serializeJSON(request.visitRecordResult)#" />
<cfelse>
  <cflocation url="#request.cancelLink#" addtoken="false"/>
</cfif>

<cfif isArray(request.visitRecordResult) and arrayLen(request.visitRecordResult) lt 1>
  <cflocation url="#request.cancelLink#" addtoken="false"/>
</cfif> 
<cfset request.visit = request.visitRecordResult[1] />

<!--- Query Participant Details for form UI --->
<cfset pptRecord = application.userQuery({
  "select": { "#request.visit.participant["@id"]#": ["@id", "pid", "firstName", "lastName", "dob"] }
})>

<cfset request.ppt = pptRecord[1] />


<!--- If submitting Edit Visit form, Transact Visit --->
<cfif structKeyExists(form, "submit")>
  <cfset transaction = {
    "where": {
      "@id": request.visit["@id"],
      "contact": "?contact",
      "visitDate": "?visitDate",
      "height": "?height",
      "pulse": "?pulse"
    },
    "delete": {
      "@id": request.visit["@id"],
      "contact": "?contact",
      "visitDate": "?visitDate",
      "height": "?height",
      "pulse": "?pulse"
    },
    "insert": {
      "@id": request.visit["@id"],
      "contact": form.contact,
      "visitDate": form.visitDate,
      "height": form.height,
      "pulse": form.pulse
    }
  } />
  <cfset variables.success = application.userTransaction(transaction) />
  <cflog text="edit visit tx: #serializeJSON(transaction)#" />
  <cfif variables.success>
    <cflocation url="#request.cancelLink#" addtoken="false"/>
  </cfif>
</cfif>


<!DOCTYPE html>
<html lang="en">
  <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      
      <title>Clinic Visit</title>
      <link rel="stylesheet" href="/app/styles/main.css"/>
      <link rel="stylesheet" href="/app/styles/dashboard.css"/>
  </head>
  <body>
      <cfinclude template="/app/templates/navbar.cfm">
      <div class="container">
          <cfif structKeyExists(url, "t")>
            <h2>Viewing Clinic Visit at t = <cfoutput>#url.t#</cfoutput></h2>
          <cfelse>
            <h2>Edit Clinic Visit</h2>
          </cfif>
          <cfif structKeyExists(variables, "success") and !variables.success>
            <p style="color: red;">Error editing clinic visit.</p>
          </cfif>
          <cfinclude template="/app/templates/forms/clinic-visit-form.cfm"/>
      </div>
  </body>
</html>
