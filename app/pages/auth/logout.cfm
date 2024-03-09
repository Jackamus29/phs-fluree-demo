<cfscript>
  session.authenticated = false;
  location("./login.cfm", false);
</cfscript>