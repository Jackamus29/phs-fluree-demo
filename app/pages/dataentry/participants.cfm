
<!--- Delete Participant --->
<cfif structKeyExists(url, "delete") and structKeyExists(url, "pid") and url.pid != "">
  <!--- The javaCast is needed because otherwise CF will add ".0" to the end of the integer when using serializeJSON --->
  <cfset local.pidFromUrl = javaCast("int", lsParseNumber(url.pid)) />
  <cfset success = application.userTransaction({
    "where": {
      "@id": "?id",
      "pid": local.pidFromUrl,
      "?attributes": "?values"
    },
    "delete": {
      "@id": "?id",
      "pid": local.pidFromUrl,
      "?attributes": "?values"
    }
  }) />
  <cflocation url="?success=#success#" addtoken="false" />
</cfif>

<!--- Participant Query --->
<cfset local.participants = application.userQuery({
    "@context": {
      "clinic": { "@reverse": "participants" },
      "visits": { "@reverse": "participant" }
    },
    "where": {
        "@id": "?ppts",
        "@type": "Participant",
        "pid": "?pid"
    },
    "select": { "?ppts": ["*", {"clinic": ["@id", "name"]}, { "visits": ["*"]}] },
    "orderBy": "?pid"
})>

<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Data Entry</title>
        <link rel="stylesheet" href="/app/styles/main.css"/>
        <link rel="stylesheet" href="/app/styles/dashboard.css"/>
    </head>
    <body>
      <cfinclude template="/app/templates/navbar.cfm">
      <div class="container">
        <h1>Study Participants</h1>
        <p>Welcome to the participants page. Here you can view and manage participant records.</p>
      
        <cfif structKeyExists(url, "success")>
          <cfif url.success>
            <p style="color: green;">Participant deleted</p>
          <cfelse>
            <p style="color: red;">Error deleting participant</p>
          </cfif>
        </cfif>
      
        <div class="add-user-btn-container">
          <a href="participant/add.cfm" class="add-user-btn">Add New Participant</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>PID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>DOB</th>
                    <th>## Visits</th>
                    <th>Clinic</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
              <cfloop array="#local.participants#" item="ppt">
                <cfif (structKeyExists(ppt, "visits"))>
                  <cfset ppt.visits = !isArray(ppt.visits) ? [ppt.visits] : ppt.visits />
                <cfelse>
                  <cfset ppt.visits = [] />
                </cfif>  
                <tr>
                    <td>#ppt.pid#</td>
                    <td>#ppt.firstName#</td>
                    <td>#ppt.lastName#</td>
                    <td>#ppt.dob#</td>
                    <td>#ArrayLen(ppt.visits)#</td>
                    <td>#(structKeyExists(ppt, "clinic") and structKeyExists(ppt.clinic, "name")) ? "#ppt.clinic.name#" : "None" #</td>
                    <td>
                        <button class="action-btn">
                          <a href="participant/edit.cfm?pid=#ppt.pid#">Edit</a>
                        </button>
                        <button class="action-btn">
                          <a href="?delete&pid=#ppt.pid#">Delete</a>
                        </button>
                    </td>
                </tr>
              </cfloop>
            </tbody>
        </table>
      </div>
    </body>
  </html>
</cfoutput>