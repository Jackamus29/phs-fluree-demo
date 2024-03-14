<!--- If user is an Admin, allow them to select any clinic --->
<cfif session.isAdmin>
  <cfset variables.clinicOptions = application.userQuery({
    "where": {
      "@id": "?id",
      "@type": "Clinic"
    },
    "select": {
      "?id": ["@id", "name"]
    }
  })/>
<cfelse>
 <!--- If the user is not an Admin, use their clinic as the only option --->
  <cfset variables.clinicQueryResults = application.userQuery({
    "select": {
      "#session.userId#": [{"clinic": ["@id", "name"]}]
    }
  })/>
  <cfset variables.clinicOptions = [clinicQueryResults[1].clinic] />
</cfif>

<cflog text="clinicOptions: #serializeJSON(variables.clinicOptions)#" />

<cfoutput>
<link rel="stylesheet" href="/app/styles/form.css" />
  <form id="addPptForm" method="post">
      <cfif structKeyExists(request.ppt, "pid")>
        <label for="id">PID:</label>
        <input type="text" id="pid" name="pid" value="#request.ppt.pid#" readonly="readonly">
      </cfif>

      <label for="firstName">First Name:</label>
      <input type="text" id="firstName" name="firstName" value="#request.ppt.firstName#" required>

      <label for="lastName">Last Name:</label>
      <input type="text" id="lastName" name="lastName" value="#request.ppt.lastName#" required>

      <label for="dob">DOB (YYYY-MM-DD):</label>
      <input type="dob" id="dob" name="dob" value="#request.ppt.dob#" required>

      <label for="clinic">Clinic:</label>
      <select id="clinic" name="clinic">
        <option value="none">-- Select a Clinic --</option>
        <cfloop array="#clinicOptions#" item="clinicOption">
          <option value="#clinicOption["@id"]#" #structKeyExists(request.ppt, "clinic") and request.ppt.clinic["@id"] == clinicOption["@id"] ? "selected" : ""#>#clinicOption.name#</option>
        </cfloop>
      </select>

      <button class="form-button" name="submit" type="submit">#structKeyExists(request.ppt, "@id") ? "Edit" : "Add"# Participant</button>
      <button class="form-button no-padding" type="button">
        <a href="#request.cancelLink#">Cancel</a>
      </button>
  </form>
</cfoutput>