import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {
    //can we put it here mysql:Client mysqlEp = check new ("localhost", "root", "root");
    # A resource for generating greetings
    # + name - the input string name
    # + return - string name with hello message or error
    resource function get greeting(string name) returns string|error {
        // Send a response back to the caller.
        if name is "" {
            return error("name should not be empty!");
        }
        return "Hello, heartly welcome, " + name;
    }

    resource function get language(string petname) returns string|error {
        // Send a response back to the caller.

        if petname is "" {
            return error("petname should not be empty!");
        }

        else if petname is "dog" {
            return petname + "says Bhaw-Bhaw";
        }

        else if petname is "cat" {
            return petname + "says Meow";
        }
        else {
            return "we don't recognise this animal";
        }
    }

    resource function post addPetVoice(string petname, string petvoice) returns string|error {
        // Send a response back to the caller.

        mysql:Client mysqlEp = check new ("localhost", "root", "root");

        sql:ExecutionResult executeResponse1 = check mysqlEp->execute(sqlQuery = `CREATE DATABASE IF NOT EXISTS dbpet`);

        sql:ExecutionResult executeResponse2 = check mysqlEp->execute(sqlQuery = `CREATE TABLE IF NOT EXISTS dbpet.tabpetvoice (
                                           petname VARCHAR(255),
                                           petvoice VARCHAR(255),
                                           PRIMARY KEY (petname)
                                         )`);
        sql:ExecutionResult executeResponse3 = check mysqlEp->execute(sqlQuery = `USE dbpet`);

        sql:ExecutionResult result = check mysqlEp->execute(`INSERT INTO tabpetvoice(petname, petvoice)
                                                        VALUES (${petname}, ${petvoice})`);

        return "pet added successfully";


    }

    resource function get knowPetVoice(string petname) returns string|error {
        // Send a response back to the caller.

        mysql:Client mysqlEp = check new ("localhost", "root", "root");

        //sql:ExecutionResult executeResponse1 = check mysqlEp->execute(sqlQuery = `CREATE DATABASE IF NOT EXISTS dbpet`);

        // sql:ExecutionResult executeResponse2 = check mysqlEp->execute(sqlQuery = `CREATE TABLE IF NOT EXISTS dbpet.tabpetvoice (
        //                                    petname VARCHAR(255),
        //                                    petvoice VARCHAR(255),
        //                                    PRIMARY KEY (petname)
        //                                  )`);
        sql:ExecutionResult executeResponse3 = check mysqlEp->execute(sqlQuery = `USE dbpet`);

        sql:ExecutionResult result = check mysqlEp->queryRow(`SELECT petvoice FROM tabpetvoice WHERE petname=${petname}`);

        return petname + " " + result.get("petvoice").toString();


    }



}
