// Application.cfc
component {
    this.name = "PHS Fluree Demo";
    this.applicationTimeout = createTimeSpan(0, 1, 30, 0);
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0, 1, 0, 0);

    // Java Integration
    this.javaSettings = {
      loadPaths: ["/lib"],
      loadColdFusionClassPath: true,
      reloadOnChange: false
    };

    FLUREE_HOST = "fluree";
    FLUREE_PORT = 8090;
    FLUREE_DATASET_NAME = "phs/cf-demo";
    FLUREE_DATASET_CONTEXT = {};

    initialData = [
        {
            "@id": "users/bsmith2",
            "@type": "User",
            "firstName": "Robert",
            "lastName": "Smith",
            "preferredName": "Buddy",
            "email": "bsmith@asu.edu"
        },
        {
            "@id": "users/agraves",
            "@type": "User",
            "firstName": "Alice",
            "lastName": "Graves",
            "email": "alice@gmail.com"
        },
        {
            "@id": "clinics/asu",
            "@type": "Clinic",
            "name": "Arizona State University",
            "url": "https://asu.edu"
        }
    ];

    function onApplicationStart() {
        // Application initialization logic
        cflog(text="Application Start");
        initializeDataset();
    }

    function onSessionStart() {
        // Session initialization logic
        cflog(text="onSessionStart");
        // set up the user's connection to Fluree, which uses the user's private key, so any pages can use it for queries and transactions
    }

    function onRequestStart(targetPage) {
        cflog(text="onRequestStart");
        // if user is not authenticated, redirect to the login page
        if (targetPage != "/pages/login.cfm" and (!structKeyExists(session, "authenticated") or !session.authenticated)) {
            location("/pages/login.cfm", false);
        }
    }

    function initializeDataset() {
        cflog(text="Transacting initialData");
        transaction = {
            "@context": FLUREE_DATASET_CONTEXT,
            "ledger": FLUREE_DATASET_NAME,
            "insert": initialData
        };
        cfhttp(url="http://#FLUREE_HOST#:#FLUREE_PORT#/fluree/create", method="post", result="flureeResponse") {
            cfhttpparam(type="header", name="Content-Type", value="application/json");
            cfhttpparam(type="body", value="#serializeJSON(transaction)#");
        }
        if (flureeResponse.Status_Code !== "201") {
            cflog(text="#serializeJSON(flureeResponse)#");
        }
    }
}
