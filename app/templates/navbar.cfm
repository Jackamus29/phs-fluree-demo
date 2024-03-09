<link rel="stylesheet" href="/app/styles/navbar.css">
<cfoutput>
  <div class="navbar">
    <span class="navbar-user-info">#session.email#</span>
    <button class="logout-button">
      <a href="/app/pages/auth/logout.cfm">Logout</a>
    </button>
  </div>
</cfoutput>