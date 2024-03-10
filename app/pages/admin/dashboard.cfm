<cfif (!structKeyExists(session, "isAdmin") or !session.isAdmin)>
  <!--- If not an Admin, redirect to site root --->
  <cflocation  url="/" addtoken="false">
</cfif>

<cfif structKeyExists(url, "delete") and structKeyExists(url, "userid") and url.userid != "">
  <cfset success = application.userTransaction({
    "where": {
      "@id": url.userid,
      "?attributes": "?values"
    },
    "delete": {
      "@id": url.userid,
      "?attributes": "?values"
    }
  }) />
  <cflocation url="?success=#success#" addtoken="false" />
</cfif>

<cfset local.users = application.userQuery({
    "where": {
        "@id": "?users",
        "@type": "User"
    },
    "select": { "?users": ["*"] }
})>

<cfoutput>
  <!DOCTYPE html>
  <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin</title>
        <link rel="stylesheet" href="/app/styles/main.css"/>
        <link rel="stylesheet" href="/app/styles/dashboard.css"/>
    </head>
    <body>
      <cfinclude template="/app/templates/navbar.cfm">
      <div class="container">
        <h1>User Management</h1>
        <p>Welcome to the user management page. Here you can view and manage user records.</p>
      
        <cfif structKeyExists(url, "success")>
          <cfif url.success>
            <p style="color: green;">User deleted</p>
          <cfelse>
            <p style="color: red;">Error deleting user</p>
          </cfif>
        </cfif>
      
        <div class="add-user-btn-container">
          <a href="add-user.cfm" class="add-user-btn">Add New User</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Is Admin</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
              <cfloop array="#local.users#" item="user">
                <!-- Example user record -->
                <tr>
                    <td>#user["@id"]#</td>
                    <td>#user.firstName#</td>
                    <td>#user.lastName#</td>
                    <td>#user.email#</td>
                    <td>#(structKeyExists(user, "isAdmin") and user.isAdmin) ? "Yes" : "No" #</td>
                    <td>
                        <button class="action-btn">
                          <a href="edit-user.cfm?userid=#encodeForUrl(user["@id"])#">Edit</a>
                        </button>
                        <button class="action-btn">
                          <a href="?delete&userid=#encodeForUrl(user["@id"])#">Delete</a>
                        </button>
                    </td>
                </tr>
              </cfloop>
            </tbody>
        </table>
      </div>

      <script>
        // JavaScript functions for editing and adding users
        function editUser(userId) {
            // Implement logic to handle user editing
            alert("Editing user with ID: " + userId);
        }

        function deleteUser(userId) {
            // Implement logic to handle user editing
            alert("Deleting user with ID: " + userId);
        }

        function addUser() {
            // Implement logic to handle adding a new user
            alert("Adding a new user");
        }
      </script>
    </body>
  </html>
</cfoutput>