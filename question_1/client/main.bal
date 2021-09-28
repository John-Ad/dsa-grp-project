import ballerina/io;

Client ep = check new ({});

public function main() {
    io:println("running add learner test -------> ");
    LearnerProfile lp = {
        firstName: "steve",
        lastName: "stevenson",
        preferred_formats: ["text"],
        username: "steve11",
        past_subjects: [{
            score: "B",
            course: "programming2"
        }, {
            score: "C",
            course: "software design"
        }]
    };
    ResponseObject|error addLpResponse = ep->add(lp);
    if addLpResponse is error {
        io:println("Failed to add user profile: ", addLpResponse.detail());
    } else {
        io:println("status: ", addLpResponse.status, "\nresponse: ", addLpResponse.message);
    }

    io:println("running update learner test -------> ");
    lp.firstName = "steffon";
    lp.lastName = "steffonson";

    ResponseObject|error updateLpResponse = ep->update(lp);
    if updateLpResponse is error {
        io:println("Failed to add user profile: ", updateLpResponse.detail());
    } else {
        io:println("status: ", updateLpResponse.status, "\nresponse: ", updateLpResponse.message);
    }

    io:println("running retrieve topics test -------> ");
    TopicObject[]|error topics = ep->topicsBylearner("distributed systems programming", lp.username);
    if topics is error {
        io:println("Failed to retrieve topics: ", topics.detail());
    } else {
        io:println("successfully retrieved topics: ", topics);
    }
}
