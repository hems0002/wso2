import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

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

        else if petname is "dog"{
            return petname + "says Bhaw-Bhaw";
        }

        else if petname is "cat"{
            return petname + "says Meow";
        }
        return "we don't recognise this animal";
    }
}
