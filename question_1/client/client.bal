import ballerina/http;

public type TopicObjectArr TopicObject[];

# restful service for managing student profiles and learning materials
#
# + clientEp - Connector http endpoint
public client class Client {
    http:Client clientEp;
    public isolated function init(http:ClientConfiguration clientConfig = {}, string serviceUrl = "http://localhost:9090/learningEnvManagement") returns error? {
        http:Client httpEp = check new (serviceUrl, clientConfig);
        self.clientEp = httpEp;
    }
    #
    # + return - successfully added learner profile
    remote isolated function add(LearnerProfile payload) returns ResponseObject|error {
        string path = string `/learner/add`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ResponseObject response = check self.clientEp->post(path, request, targetType = ResponseObject);
        return response;
    }
    #
    # + return - successfully updated learner profile
    remote isolated function update(LearnerProfile payload) returns ResponseObject|error {
        string path = string `/learner/update`;
        http:Request request = new;
        json jsonBody = check payload.cloneWithType(json);
        request.setPayload(jsonBody);
        ResponseObject response = check self.clientEp->post(path, request, targetType = ResponseObject);
        return response;
    }
    #
    # + course - existing course name
    # + learner - existing learner username
    # + return - successfully retrieved material
    remote isolated function topicsBylearner(string course, string learner) returns TopicObjectArr|error {
        string path = string `/learningMaterials/${course}/${learner}`;
        TopicObjectArr response = check self.clientEp->get(path, targetType = TopicObjectArr);
        return response;
    }
}
