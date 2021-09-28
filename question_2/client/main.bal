import ballerina/io;
import ballerina/grpc;

ReposityOfFunctionsClient ep = check new ("http://localhost:9090");

public function main() {
    // run tests for adding new fns
    io:println("### TESTING ADD NEW FN ###");
    AddFnRequest addFnReq = {
        fn: {
            name: "sayName",
            lang: "c++",
            keywords: ["names", "strings"],
            devEmail: "email@email.com",
            devName: "paulus"
        },
        vs: {
            versionNum: 1,
            fnDef: "string sayName(string name){return \"Hi, my name is\"+name;}"
        }
    };
    AddFnResponse|grpc:Error addFnsRes = ep->add_new_fn(addFnReq);
    if addFnsRes is error {
        io:println("Error adding new fn: ", addFnsRes.message());
    } else {
        io:println("Success: ", addFnsRes.message);
    }
    //##################################################

    io:println("### TESTING ADD FNS ###");
    AddFnsRequest[] addFnsReq = [
    { // should succeed (completely new function)
        func: {
            name: "printHi",
            lang: "python",
            keywords: ["strings"],
            devEmail: "rand@rand.com",
            devName: "randy"
        },
        vs: {
            versionNum: 1,
            fnDef: "print('hi')"
        }
    }, 
    { // should fail (multiple versions of same func in same stream not allowed )
        func: {
            name: "printHi",
            lang: "python",
            keywords: ["strings"],
            devEmail: "rand@rand.com",
            devName: "randy"
        },
        vs: {
            versionNum: 2,
            fnDef: "print('hi. Hello')"
        }
    }, 
    { // should succeed (new version of existing fn not previously in stream)
        func: {
            name: "sayName",
            lang: "c++",
            keywords: ["names", "strings"],
            devEmail: "email@email.com",
            devName: "paulus"
        },
        vs: {
            versionNum: 2,
            fnDef: "string sayName(string name){return \"Hello there, my name is\"+name;}"
        }
    }
];
    Add_fnsStreamingClient|grpc:Error addFnsStream = ep->add_fns();
    if addFnsStream is error {
        io:println("error added fns: ", addFnsStream.message());
    } else {
        foreach AddFnsRequest aFReq in addFnsReq {
            grpc:Error? err = addFnsStream->sendAddFnsRequest(aFReq);
            if err is error {
                io:println("Failed to send addFns req");
            }
        }

        grpc:Error? err = addFnsStream->complete();
        if err is error {
            io:println("Failed to send complete message");
        } else {
            AddFnsResponse|grpc:Error? fnsRes = addFnsStream->receiveAddFnsResponse();
            if fnsRes is error {
                io:println("Failed to retrieve addFnsRes: ", fnsRes.message());
            } else {
                if fnsRes is AddFnsResponse {
                    foreach string msg in fnsRes.results {
                        io:println(msg);
                    }
                }
            }
        }

    }

    io:println("### TESTING SHOW FN ###");
    ShowFnRequest showFnReq = {
        funcName: "printHi",
        versionNum: 1
    };
    ShowFnResponse|grpc:Error showFnRes = ep->show_fn(showFnReq);
    if showFnRes is error {
        io:println("Error retrieving version: ", showFnRes.message());
    } else {
        io:println("Success: ", showFnRes.vs);
    }

    io:println("### TESTING SHOW ALL FNS ###");
    ShowAllFnsRequest showAllFnsReq = {
        funcName: "sayName"
    };
    stream<ShowAllFnsResponse, grpc:Error?>|grpc:Error showAllFnsStream = ep->show_all_fns(showAllFnsReq);
    if showAllFnsStream is error {
        io:println("Failed to show all versions: ", showAllFnsStream.message());
    } else {
        error? e = showAllFnsStream.forEach(function(ShowAllFnsResponse res) {
            io:println("Successfully retrieved version: ", res.vs);
        });
    }

    io:println("### TESTING SHOW ALL WITH CRITERIA ###");
    ShowAllWithCritRequest[] showAllWithCritReqs = [{
        // should return all functions that were successfully added above
        keywords: ["strings"],
        lang: ""
    }, {
        // should return sayHello only
        keywords: [],
        lang: "c++"
    }
    ];
    Show_all_with_criteriaStreamingClient|grpc:Error showAllWithCritStream = ep->show_all_with_criteria();
    if showAllWithCritStream is error {
        io:println("error occured setting up showAllWithCrit stream: ", showAllWithCritStream.message());
    } else {
        foreach ShowAllWithCritRequest showAllWithCritReq in showAllWithCritReqs {
            error? err = showAllWithCritStream->sendShowAllWithCritRequest(showAllWithCritReq);
            if err is error {
                io:println("failed to send showAllWithCriteria req: ", err.message());
            }
        }
        error? err = showAllWithCritStream->complete();
        if err is error {
            io:println("failed to send showAllWithCriteria complete message: ", err.message());
        }

        ShowAllWithCritResponse|grpc:Error? showAllWithCritRes = showAllWithCritStream->receiveShowAllWithCritResponse();
        while true {
            if showAllWithCritRes is error {
                io:println("failed to send showAllWithCriteria complete message: ", showAllWithCritRes.message());
                break;
            } else {
                if showAllWithCritRes is () {
                    break;
                } else {
                    io:println("showAllWithCriteria response: ", showAllWithCritRes.versions);
                    showAllWithCritRes = showAllWithCritStream->receiveShowAllWithCritResponse();
                }
            }
        }
    }

    io:println("### TESTING SHOW ALL WITH CRITERIA ###");
    DeleteFnRequest delFnReq = {
        funcName: "printHi",
        versionNum: 1
    };
    DeleteFnResponse|grpc:Error delRes = ep->delete_fn(delFnReq);
    if delRes is error {
        io:println("Error deleting fn: ", delRes.message());
    } else {
        io:println("Success: ", delRes.message);
    }
}
