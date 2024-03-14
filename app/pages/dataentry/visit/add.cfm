<cfset request.cancelLink = "/app/pages/dataentry/participants.cfm"/>

<!--- Query Participant Details for form UI --->
<cfif structKeyExists(url, "pid") and url.pid != "">
  <!--- The javaCast is needed because otherwise CF will add ".0" to the end of the integer when using serializeJSON --->
  <cfset local.pidFromUrl = javaCast("int", lsParseNumber(url.pid)) />
  <cfset pptRecord = application.userQuery({
    "where": { 
      "@id": "?ppt",
      "pid": local.pidFromUrl
    },
    "select": { "?ppt": ["@id", "name", "pid", "dob"] }
  })>
<cfelse>
  <cflocation url="#request.cancelLink#" addtoken="false"/>
</cfif>

<cfset request.ppt = pptRecord[1] />


<!--- If submitting Add Visit form, Transact Visit --->
<cfif structKeyExists(form, "submit")>
  <cfset transaction = {
    "insert": {
      "@id": "forms/clinic-visit/#request.ppt.pid#/#local.nextContact#",
      "@type": ["FormResponse", "ClinicVisit"],
      "contact": form.contact,
      "participant": { "@id": request.ppt["@id"] },
      "visitDate": form.visitDate,
      "height": form.height,
      "pulse": form.pulse
    }
  } />
  <cfset variables.success = application.userTransaction(transaction) />
  <cflog text="add participant tx: #serializeJSON(transaction)#" />
  <cfif variables.success>
    <cflocation url="#request.cancelLink#" addtoken="false"/>
  </cfif>
</cfelse>
  <!---  Prepare the New Clinic Visit Form  --->
  <!---  Get the next Contact number for this participant  --->
  <cfset local.maxContactResult = application.appQuery({
    "where": {
      "@type": "ClinicVisit",
      "participant": request.ppt["@id"],
      "contact": "?contacts"
    },
    "select": [ "(max ?contacts)"]
  }) />
  <!--- The javaCast is needed because otherwise CF will add ".0" to the end of the integer when using serializeJSON --->
  <cfset local.nextContact = javaCast("int", local.maxContactResult[1][1] + 1) />

  <!--- New Visit record --->
  <cfset request.visit = {
    "contact": local.nextContact,
    "participant": request.ppt["@id"],
    "visitDate": "",
    "height": 0,
    "pulse": 0
  } />
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
          <h2>New Clinic Visit</h2>
          <cfif structKeyExists(variables, "success") and !variables.success>
            <p style="color: red;">Error adding new user.</p>
          </cfif>
          <cfinclude template="/app/templates/forms/clinic-visit-form.cfm"/>
      </div>
  </body>
</html>
