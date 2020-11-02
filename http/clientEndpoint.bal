import ballerina/http;
import ballerina/io;

http:Client clientEndpoint = new ("http://postman-echo.com");

public function main() {
    io:println("GET request:");

    var response = clientEndpoint->get("/get?test=123");

    handleResponse(response);

    io:println("\nPOST request:");

    //Post method do not send data in the link
    response = clientEndpoint->post("/post", {"it":"Hello World","name":123});

    handleResponse(response);

    io:println("\nUse custom HTTP verbs:");

    response = clientEndpoint->execute("COPY", "/get", "CUSTOM: Hello World");

    //check adding header 
    http:Request req = new;
    req.addHeader("name","value");

    http:Response|http:Payload|error resposeRecievedNow = clientEndpoint->get("/get", req);
    if (resposeRecievedNow is http:Response) {

        string contentType = resposeRecievedNow.getContentType();
        io:println("Content-Type: " + contentType);

        int statusCode = resposeRecievedNow.statusCode;
        io:println("Status code: " + statusCode.toString());

    } else {
        io:println("Error when calling the backend: ",
                            (<error>response).message());
    }
}

function handleResponse(http:Response|http:Payload|error response) {
    if (response is http:Response) {

        var msg = response.getJsonPayload();
        if (msg is json) {

            io:println(msg.toJsonString());
        } else {
            io:println("Invalid payload received:", msg.message());
        }
    } else {
        io:println("Error when calling the backend: ",
                            (<error>response).message());
    }
}