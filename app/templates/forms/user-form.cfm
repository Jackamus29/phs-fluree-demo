<cfset local.isAdmin = (structKeyExists(request.user, "isAdmin") and request.user.isAdmin)/>

<cfset variables.clinicOptions = application.userQuery({
  "where": {
    "@id": "?id",
    "@type": "Clinic"
  },
  "select": {
    "?id": ["@id", "name"]
  }
})/>

<cfoutput>
<link rel="stylesheet" href="/app/styles/form.css" />
  <form id="addUserForm" method="post">
      <cfif structKeyExists(request.user, "@id")>
        <label for="id">User ID:</label>
        <input type="text" id="id" name="@id" value="#request.user["@id"]#" readonly="readonly">
      </cfif>

      <label for="firstName">First Name:</label>
      <input type="text" id="firstName" name="firstName" value="#request.user.firstName#" required>

      <label for="lastName">Last Name:</label>
      <input type="text" id="lastName" name="lastName" value="#request.user.lastName#" required>

      <label for="email">Email:</label>
      <input type="email" id="email" name="email" value="#request.user.email#" required>

      <label for="isAdmin">Is Admin:</label>
      <select id="isAdmin" name="isAdmin">
          <option value="true" #local.isAdmin? "selected" : ""#>Yes</option>
          <option value="false" #!local.isAdmin ? "selected" : ""#>No</option>
      </select>

      <label for="clinic">Clinic:</label>
      <select id="clinic" name="clinic">
        <option value="none">-- Select a Clinic --</option>
        <cfloop array="#clinicOptions#" item="clinicOption">
          <option value="#clinicOption["@id"]#" #structKeyExists(request.user, "clinic") and request.user.clinic["@id"] == clinicOption["@id"] ? "selected" : ""#>#clinicOption.name#</option>
        </cfloop>
      </select>

      <button class="form-button" name="submit" type="submit">#structKeyExists(request.user, "@id") ? "Edit" : "Add"# User</button>
      <button class="form-button no-padding" type="button">
        <a href="#request.cancelLink#">Cancel</a>
      </button>
  </form>
</cfoutput>