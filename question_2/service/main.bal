import ballerina/grpc;

listener grpc:Listener ep = new (9090);

Func[] functions = [];
map<FuncVersion[]> funcVersions = {};

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "ReposityOfFunctions" on ep {

    remote function add_new_fn(AddFnRequest value) returns AddFnResponse|error {
        // check if func already exists
        foreach Func func in functions {
            if func.name == value.fn.name {
                // check if version provided already exists
                if funcVersions.hasKey(func.name) {
                    FuncVersion[] fnVs = funcVersions.get(func.name);
                    foreach FuncVersion vs in fnVs {
                        if vs.versionNum == value.vs.versionNum {
                            return error("Function version already exists");
                        }
                    }

                    if value.vs.versionNum <= fnVs.length() + 1 {
                        int vsNum = fnVs.length() + 1;
                        return error("wrong version number specified. expected: " + vsNum.toString());
                    }

                    // add new version
                    fnVs.push(value.vs);
                    funcVersions[func.name] = fnVs;
                } else {
                    // add new version
                    funcVersions[func.name] = [value.vs];
                }
                return {message: "successfully added func"};
            }
        }

        functions.push(value.fn);
        funcVersions[value.fn.name] = [value.vs];

        return {message: "successfully added func"};
    }

    remote function delete_fn(DeleteFnRequest value) returns DeleteFnResponse|error {
        // search for fn to delete
        foreach Func func in functions {
            if func.name == value.funcName {
                boolean reorder = false;
                if funcVersions.hasKey(func.name) {
                    FuncVersion[] versions = funcVersions.get(func.name);
                    if versions.length() > 0 {
                        boolean removed = false;
                        int i = 0;
                        // loop through version and find right one
                        while i < versions.length() {
                            // if version was deleted, reorder subsequent functions
                            if reorder {
                                versions[i].versionNum -= 1;
                            }

                            // delete version if exists
                            if !reorder && versions[i].versionNum == value.versionNum {
                                FuncVersion vsNum = versions.remove(i);
                                removed = true;
                                i -= 1;
                            }

                            i += 1;
                        }

                        if !removed {
                            return error("no matching version found");
                        } else {
                            return {message: "successfully removed func version: " + value.versionNum.toString()};
                        }
                    }
                }
                return error("no versions to delete");
            }
        }
        return error("function not found");
    }

    remote function show_fn(ShowFnRequest value) returns ShowFnResponse|error {
        // search functions for matching one
        foreach Func func in functions {
            if func.name == value.funcName {
                // search versions for correct one
                if funcVersions.hasKey(func.name) {
                    foreach FuncVersion vs in funcVersions.get(func.name) {
                        if vs.versionNum == value.versionNum {
                            // return correct version if found
                            return {vs: vs};
                        }
                    }
                    // return error if version not found
                    return error("Version not found");
                } else {
                    return error("No versions to retrieve");
                }
            }
        }
        // return error if function not found
        return error("function not found");
    }

    remote function add_fns(stream<AddFnsRequest, grpc:Error?> clientStream) returns AddFnsResponse|error {
        Func[] funcsToAdd = [];
        map<FuncVersion> versionsToAdd = {};
        AddFnsResponse response = {
            results: []
        };

        error? err = clientStream.forEach(function(AddFnsRequest request) {
            boolean funcFound = false;
            foreach Func func in functions {
                // function exists, just add new version
                if func.name == request.func.name {
                    funcFound = true;
                    if funcVersions.hasKey(func.name) {
                        // check if version already exists
                        foreach FuncVersion vs in funcVersions.get(func.name) {
                            if vs.versionNum == request.vs.versionNum {
                                response.results.push("version already exists: " + func.name);
                                break;
                            }
                        }

                        // check if a previous request contained version
                        if versionsToAdd.hasKey(func.name) {
                            response.results.push("multiple versions not allowed in stream: " + func.name);
                        } else {
                            // add func to list to be added
                            funcsToAdd.push(request.func);
                            // add version 
                            versionsToAdd[func.name] = request.vs;
                        }
                    }
                }
            }

            if !funcFound {
                // check if a previous request contained version
                if versionsToAdd.hasKey(request.func.name) {
                    response.results.push("multiple versions not allowed in stream: " + request.func.name);
                } else {
                    // add func to list to be added
                    funcsToAdd.push(request.func);
                    // add version 
                    versionsToAdd[request.func.name] = request.vs;
                }
            }
        });

        if err is error {
            return error("unexpected error occurred");
        }

        foreach Func func in funcsToAdd {
            // each function has a version array mapped to it, if not, its a completely new function
            if funcVersions.hasKey(func.name) {
                FuncVersion[] versions = funcVersions.get(func.name);
                versions.push(versionsToAdd.get(func.name));
                funcVersions[func.name] = versions;
            } else {
                functions.push(func);
                funcVersions[func.name] = [versionsToAdd.get(func.name)];
            }
            response.results.push("added func: " + func.name);
        }

        return response;
    }

    remote function show_all_fns(ShowAllFnsRequest value) returns stream<ShowAllFnsResponse, error?>|error {
        ShowAllFnsResponse[] responses = [];
        foreach Func func in functions {
            if func.name == value.funcName {
                if funcVersions.hasKey(func.name) {
                    FuncVersion[] versions = funcVersions.get(func.name);
                    foreach FuncVersion vs in versions {
                        ShowAllFnsResponse response = {
                            vs: {}
                        };
                        response.vs = vs;
                        responses.push(response);
                    }
                } else {
                    return error("no versions found");
                }
            }
        }

        if responses.length() == 0 {
            return error("function not found");
        }

        return responses.toStream();
    }

    remote function show_all_with_criteria(stream<ShowAllWithCritRequest, grpc:Error?> clientStream) returns stream<ShowAllWithCritResponse, error?>|error {

        ShowAllWithCritResponse[] responses = [];

        // search each function
        error? err = clientStream.forEach(function(ShowAllWithCritRequest request) {
            ShowAllWithCritResponse response = {
                versions: []
            };
            foreach Func func in functions {
                boolean matchFound = false;
                if func.lang == request.lang {
                    matchFound = true;
                }
                if !matchFound {
                    foreach string keyword in func.keywords {
                        foreach string reqKeyword in request.keywords {
                            if reqKeyword == keyword {
                                matchFound = true;
                                break;
                            }
                        }
                        if matchFound {
                            break;
                        }
                    }
                }
                if matchFound {
                    if funcVersions.hasKey(func.name) {
                        FuncVersion[] versions = funcVersions.get(func.name);
                        if versions.length() > 0 {
                            response.versions.push(versions[versions.length() - 1]);
                        }
                    }
                }
            }
            responses.push(response);
        });

        if err is error {
            return error("unexpected error");
        }

        return responses.toStream();
    }
}
