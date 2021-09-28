public type TopicObject record {
    string name;
    string description;
    string difficulty;
};

public type LearnerProfile record {
    string username;
    string firstName;
    string lastName;
    string[] preferred_formats;
    record  { string course; string score;} [] past_subjects;
};

public type LearningObject record {
    MaterialObject[] audio;
    MaterialObject[] video;
    MaterialObject[] text;
};

public type MaterialObject record {
    string name;
    string description;
    string difficulty;
};

public type ResponseObject record {
    string status;
    string message;
};

public type LearningMaterial record {
    string course;
    LearningObject learning_objects;
};

public type RequestObject record {
    string message;
};
