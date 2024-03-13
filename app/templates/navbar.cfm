<link rel="stylesheet" href="/app/styles/navbar.css">
<cfoutput>
  <div class="navbar">
    <span class="navbar-user-info">#session.email#</span>
    
    <cfif structKeyExists(session, "isAdmin") and session.isAdmin>
      <button class="nav-button">
        <cfif cgi.script_name != "/app/pages/admin/dashboard.cfm">
          <a href="/app/pages/admin/dashboard.cfm">Go To Admin Dashboard</a>
        <cfelse>
          <a href="/app/pages/dataentry/participants.cfm">Go To Data Entry</a>
        </cfif>
      </button>
    </cfif>

    <button class="nav-button logout-button">
      <a href="/app/pages/auth/logout.cfm">Logout</a>
    </button>
  </div>
</cfoutput>