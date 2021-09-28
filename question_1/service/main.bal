import ballerina/http;

//  stores the learner profiles
LearnerProfile[] learners = [];
//  stores the learning materials
LearningMaterial[] materials = [{
    course: "distributed systems programming",
    learning_objects: {
        audio: [{
            name: "course outline",
            difficulty: "1",
            description: "we discuss what the course is about"
        }],
        video: [{
            name: "course outline",
            difficulty: "1",
            description: "we discuss what the course is about"
        }],
        text: [{
            name: "course outline",
            difficulty: "1",
            description: "we discuss what the course is about"
        }]
    }
}, 
{
    course: "ethics for computing",
    learning_objects: {
        audio: [{
            name: "intro to ethics",
            difficulty: "2",
            description: "we discuss basic ethics"
        }],
        video: [{
            name: "intro to ethics",
            difficulty: "2",
            description: "we discuss basic ethics"
        }],
        text: [{
            name: "intro to ethics",
            difficulty: "2",
            description: "we discuss basic ethics"
        }]
    }
}];

listener http:Listener ep0 = new (9090, config = {host: "localhost"});

service /learningEnvManagement on ep0 {
    resource function post learner/add(@http:Payload {} LearnerProfile payload) returns ResponseObject|record {|*http:BadRequest; ResponseObject body;|} {
        // check if learner exists
        if learners.length() > 0 {
            foreach int i in 0 ... learners.length() {
                if learners[i].username == payload.username {
                    // return error message
                    return {
                        body: {
                            status: "error",
                            message: "user already exists"
                        }
                    };
                }
            }
        }
        // add learner to array
        learners.push(payload);

        // return success message
        return {
            status: "ok",
            message: "successfully added user"
        };
    }

    resource function post learner/update(@http:Payload {} LearnerProfile payload) returns ResponseObject|record {|*http:BadRequest; ResponseObject body;|} {
        // check if learner exists
        if learners.length() > 0 {
            foreach int i in 0 ... learners.length() {
                if learners[i].username == payload.username {
                    // override old learner profile with new one
                    learners[i] = payload;
                    return {
                        status: "ok",
                        message: "successfully updated learner profile"
                    };
                }
            }
        }

        // return error message
        return {
            status: "error",
            message: "learner profile not found"
        };
    }

    resource function get learningMaterials/[string course]/[string learner]() returns TopicObject[]|record {|*http:BadRequest; ResponseObject body;|} {
        boolean userFound = false;
        boolean courseFound = false;
        TopicObject[] courseTopics = [];
        // check if learner exists
        foreach LearnerProfile learnerProfile in learners {
            if learnerProfile.username == learner {
                userFound = true;
                // check if course exists
                foreach LearningMaterial material in materials {
                    if material.course == course {
                        courseFound = true;
                        // find max score
                        string max = "F";

                        foreach var pastSub in learnerProfile.past_subjects {
                            if pastSub.score < max {
                                max = pastSub.score;
                            }
                        }

                        // use max score to retrieve learning objects suitable for learner
                        int difficulty = convertToDifficulty(max);

                        foreach var text in material.learning_objects.text {
                            int|error textDifficulty = int:fromString(text.difficulty);
                            if textDifficulty is int {
                                if textDifficulty <= difficulty {
                                    courseTopics.push(text);
                                }
                            }
                        }
                        foreach var audio in material.learning_objects.audio {
                            int|error audioDifficulty = int:fromString(audio.difficulty);
                            if audioDifficulty is int {
                                if audioDifficulty <= difficulty {
                                    courseTopics.push(audio);
                                }
                            }
                        }
                        foreach var video in material.learning_objects.video {
                            int|error videoDifficulty = int:fromString(video.difficulty);
                            if videoDifficulty is int {
                                if videoDifficulty <= difficulty {
                                    courseTopics.push(video);
                                }
                            }
                        }

                    }
                }
            }
        }

        if !userFound {
            return {
                body: {
                    status: "error",
                    message: "learner not found"
                }
            };
        }
        if !courseFound {
            return {
                body: {
                    status: "error",
                    message: "course not found"
                }
            };
        }

        // check if topics were found
        if courseTopics.length() == 0 {
            return {
                body: {
                    status: "error",
                    message: "no topics for course found"
                }
            };
        }

        // return topics
        return courseTopics;
    }
}

function convertToDifficulty(string score) returns int {
    if score == "A" || score == "B" {
        return 3;
    }
    if score == "C" || score == "D" {
        return 2;
    }
    if score == "E" || score == "F" {
        return 1;
    }
    return 0;
}
