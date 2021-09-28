import ballerina/io;

ReposityOfFunctionsClient ep = check new ("http://localhost:9090");

public function main() {
    io:println("Hello World!");
}
