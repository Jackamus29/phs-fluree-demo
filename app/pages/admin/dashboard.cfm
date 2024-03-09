<cfif (!structKeyExists(session, "isAdmin") or !session.isAdmin)>
  <!--- If not an Admin, redirect to site root --->
  <cflocation  url="/" addtoken="false">
</cfif>

<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>
        <link rel="stylesheet" href="/app/styles/main.css"/>
    </head>
    <body>
      <cfinclude template="/app/templates/navbar.cfm">
      <h1>Admin Dashboard</h1>
    </body>
  </html>
</cfoutput>