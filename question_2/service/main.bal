import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:ServiceDescriptor {descriptor: ROOT_DESCRIPTOR, descMap: getDescriptorMap()}
service "ReposityOfFunctions" on ep {

    remote function add_new_fn(AddFnRequest value) returns AddFnResponse|error {
        return error("not finished");
    }
    remote function delete_fn(DeleteFnRequest value) returns DeleteFnResponse|error {
        return error("not finished");
    }
    remote function show_fn(ShowFnRequest value) returns ShowFnResponse|error {
        return error("not finished");
    }
    remote function add_fns(stream<AddFnsRequest, grpc:Error?> clientStream) returns AddFnsResponse|error {
        return error("not finished");
    }
    remote function show_all_fns(ShowAllFnsRequest value) returns stream<ShowAllFnsResponse, error?>|error {
        return error("not finished");
    }
    remote function show_all_with_criteria(stream<ShowAllWithCritRequest, grpc:Error?> clientStream) returns stream<ShowAllWithCritResponse, error?>|error {
        return error("not finished");
    }
}
