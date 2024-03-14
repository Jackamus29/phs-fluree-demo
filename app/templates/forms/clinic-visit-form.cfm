<cfoutput>
<link rel="stylesheet" href="/app/styles/form.css" />
  <form id="visitForm" method="post">
    <fieldset>
      <legend>Participant Information</legend>

      <label for="id">PID:</label>
      <input type="text" id="pid" name="pid" value="#request.ppt.pid#" disabled>

      <label for="firstName">First Name:</label>
      <input type="text" id="firstName" name="firstName" value="#request.ppt.firstName#" disabled>

      <label for="lastName">Last Name:</label>
      <input type="text" id="lastName" name="lastName" value="#request.ppt.lastName#" disabled>

      <label for="dob">DOB (YYYY-MM-DD):</label>
      <input type="dob" id="dob" name="dob" value="#request.ppt.dob#" disabled>
    </fieldset>
      
    <cfif structKeyExists(request.visit, "pid")>
      <input id="@id" name="@id" value="#request.visit["@id"]#" hidden>
    </cfif>
    <label for="contact">Visit ##:</label>
    <input type="number" id="contact" name="contact" value="#request.visit.contact#">

    <label for="visitDate">Visit Date:</label>
    <input type="date" id="visitDate" name="visitDate" value="#request.visit.visitDate#">

    <label for="height">Height:</label>
    <input type="number" id="height" name="height" value="#request.visit.height#">

    <label for="pulse">Pulse:</label>
    <input type="number" id="pulse" name="pulse" value="#request.visit.pulse#">

    <button class="form-button" name="submit" type="submit">#structKeyExists(request.visit, "@id") ? "Edit" : "Add"# Clinic Visit</button>
    <button class="form-button no-padding" type="button">
      <a href="#request.cancelLink#">Cancel</a>
    </button>
  </form>
</cfoutput>