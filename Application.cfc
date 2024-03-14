// Application.cfc
component {
    this.name = "PHS Fluree Demo";
    this.applicationTimeout = createTimeSpan(0, 1, 30, 0);
    this.sessionManagement = true;
    this.sessionTimeout = createTimeSpan(0, 1, 0, 0);

    FLUREE_HOST = "fluree";
    FLUREE_PORT = 8090;
    application.FLUREE_DATASET_NAME = "phs/cf-demo";
    application.FLUREE_DATASET_CONTEXT = {};

    // initialData = [];

    function onApplicationStart() {
        // Application initialization logic
        cflog(text="Application Start");
        // initializeDataset();

        // function for sending a Fluree Query, to be used by app service, not a user
        application.appQuery = function(query) {
            // combine any provided @context with the application-level context (don't overwrite provided values)
            structAppend((structKeyExists(arguments.query, "@context") ? arguments.query["@context"] : {}), application.FLUREE_DATASET_CONTEXT, false);
            arguments.query["from"] = application.FLUREE_DATASET_NAME;

            local.serializedQuery = serializeJSON(arguments.query);
            
            cfhttp(url="http://#FLUREE_HOST#:#FLUREE_PORT#/fluree/query", method="post", result="flureeResponse") {
                cfhttpparam(type="header", name="Content-Type", value="application/json");
                cfhttpparam(type="body", value=local.serializedQuery);
            }
            local.responseData = deserializeJSON(flureeResponse.Filecontent);
            cflog(text="#serializeJSON(local.responseData)#");
            return local.responseData;
        }

        // function for sending a Fluree Transaction, to be used by app service, not a user
        application.appTransaction = function(tx) {
            // combine any provided @context with the application-level context (don't overwrite provided values)
            structAppend((structKeyExists(arguments.tx, "@context") ? arguments.tx["@context"] : {}), application.FLUREE_DATASET_CONTEXT, false);
            arguments.tx["ledger"] = application.FLUREE_DATASET_NAME;

            local.serializedTx = serializeJSON(arguments.tx);
            
            cfhttp(url="http://#FLUREE_HOST#:#FLUREE_PORT#/fluree/transact", method="post", result="flureeResponse") {
                cfhttpparam(type="header", name="Content-Type", value="application/json");
                cfhttpparam(type="body", value=local.serializedTx);
            }
            return flureeResponse.Statuscode == "200 OK";
        }

        // function for sending a Fluree Query, to be used by the app user
        // (the query is signed on behalf of the user)
        application.userQuery = function(query) {
            // combine any provided @context with the application-level context (don't overwrite provided values)
            structAppend((structKeyExists(arguments.query, "@context") ? arguments.query["@context"] : {}), application.FLUREE_DATASET_CONTEXT, false);
            arguments.query["from"] = application.FLUREE_DATASET_NAME;

            local.serializedQuery = serializeJSON(arguments.query);
            
            cfhttp(url="http://#FLUREE_HOST#:#FLUREE_PORT#/fluree/query", method="post", result="flureeResponse") {
                cfhttpparam(type="header", name="Content-Type", value="application/json");
                cfhttpparam(type="body", value=local.serializedQuery);
            }
            local.responseData = deserializeJSON(flureeResponse.Filecontent);
            cflog(text="#serializeJSON(local.responseData)#");
            return local.responseData;
        }

        // function for sending a Fluree Transaction, to be used by the app user
        // (the transaction is signed on behalf of the user)
        application.userTransaction = function(tx) {
            // combine any provided @context with the application-level context (don't overwrite provided values)
            structAppend((structKeyExists(arguments.tx, "@context") ? arguments.tx["@context"] : {}), application.FLUREE_DATASET_CONTEXT, false);
            arguments.tx["ledger"] = application.FLUREE_DATASET_NAME;

            local.serializedTx = serializeJSON(arguments.tx);
            
            cfhttp(url="http://#FLUREE_HOST#:#FLUREE_PORT#/fluree/transact", method="post", result="flureeResponse") {
                cfhttpparam(type="header", name="Content-Type", value="application/json");
                cfhttpparam(type="body", value=local.serializedTx);
            }
            return flureeResponse.Statuscode == "200 OK";
        }
    }

    function onSessionStart() {
        // Session initialization logic
        cflog(text="onSessionStart");
        // set up the user's connection to Fluree, which uses the user's private key, so any pages can use it for queries and transactions
    }

    function onRequestStart(targetPage) {
        cflog(text="onRequestStart");
        // if user is not authenticated, redirect to the login page
        if (targetPage != "/app/pages/auth/login.cfm" and (!structKeyExists(session, "authenticated") or !session.authenticated)) {
            location("/app/pages/auth/login.cfm", false);
        }
    }

    function initializeDataset() {
        cflog(text="Transacting initialData");
        transaction = {
            "@context": application.FLUREE_DATASET_CONTEXT,
            "ledger": application.FLUREE_DATASET_NAME,
            "insert": initialData
        };
        cfhttp(url="http://#FLUREE_HOST#:#FLUREE_PORT#/fluree/create", method="post", result="flureeResponse") {
            cfhttpparam(type="header", name="Content-Type", value="application/json");
            cfhttpparam(type="body", value="#serializeJSON(transaction)#");
        }
        if (flureeResponse.Responseheader.Status_Code !== "201") {
            cflog(text="#serializeJSON(flureeResponse)#");
        }
    }
}
