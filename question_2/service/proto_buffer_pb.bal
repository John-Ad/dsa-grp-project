import ballerina/grpc;

public isolated client class ReposityOfFunctionsClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ROOT_DESCRIPTOR, getDescriptorMap());
    }

    isolated remote function add_new_fn(AddFnRequest|ContextAddFnRequest req) returns (AddFnResponse|grpc:Error) {
        map<string|string[]> headers = {};
        AddFnRequest message;
        if (req is ContextAddFnRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ReposityOfFunctions/add_new_fn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddFnResponse>result;
    }

    isolated remote function add_new_fnContext(AddFnRequest|ContextAddFnRequest req) returns (ContextAddFnResponse|grpc:Error) {
        map<string|string[]> headers = {};
        AddFnRequest message;
        if (req is ContextAddFnRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ReposityOfFunctions/add_new_fn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddFnResponse>result, headers: respHeaders};
    }

    isolated remote function delete_fn(DeleteFnRequest|ContextDeleteFnRequest req) returns (DeleteFnResponse|grpc:Error) {
        map<string|string[]> headers = {};
        DeleteFnRequest message;
        if (req is ContextDeleteFnRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ReposityOfFunctions/delete_fn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <DeleteFnResponse>result;
    }

    isolated remote function delete_fnContext(DeleteFnRequest|ContextDeleteFnRequest req) returns (ContextDeleteFnResponse|grpc:Error) {
        map<string|string[]> headers = {};
        DeleteFnRequest message;
        if (req is ContextDeleteFnRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ReposityOfFunctions/delete_fn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <DeleteFnResponse>result, headers: respHeaders};
    }

    isolated remote function show_fn(ShowFnRequest|ContextShowFnRequest req) returns (ShowFnResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ShowFnRequest message;
        if (req is ContextShowFnRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ReposityOfFunctions/show_fn", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ShowFnResponse>result;
    }

    isolated remote function show_fnContext(ShowFnRequest|ContextShowFnRequest req) returns (ContextShowFnResponse|grpc:Error) {
        map<string|string[]> headers = {};
        ShowFnRequest message;
        if (req is ContextShowFnRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("ReposityOfFunctions/show_fn", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ShowFnResponse>result, headers: respHeaders};
    }

    isolated remote function add_fns() returns (Add_fnsStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("ReposityOfFunctions/add_fns");
        return new Add_fnsStreamingClient(sClient);
    }

    isolated remote function show_all_fns(ShowAllFnsRequest|ContextShowAllFnsRequest req) returns stream<ShowAllFnsResponse, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ShowAllFnsRequest message;
        if (req is ContextShowAllFnsRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("ReposityOfFunctions/show_all_fns", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ShowAllFnsResponseStream outputStream = new ShowAllFnsResponseStream(result);
        return new stream<ShowAllFnsResponse, grpc:Error?>(outputStream);
    }

    isolated remote function show_all_fnsContext(ShowAllFnsRequest|ContextShowAllFnsRequest req) returns ContextShowAllFnsResponseStream|grpc:Error {
        map<string|string[]> headers = {};
        ShowAllFnsRequest message;
        if (req is ContextShowAllFnsRequest) {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("ReposityOfFunctions/show_all_fns", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ShowAllFnsResponseStream outputStream = new ShowAllFnsResponseStream(result);
        return {content: new stream<ShowAllFnsResponse, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function show_all_with_criteria() returns (Show_all_with_criteriaStreamingClient|grpc:Error) {
        grpc:StreamingClient sClient = check self.grpcClient->executeBidirectionalStreaming("ReposityOfFunctions/show_all_with_criteria");
        return new Show_all_with_criteriaStreamingClient(sClient);
    }
}

public client class Add_fnsStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendAddFnsRequest(AddFnsRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextAddFnsRequest(ContextAddFnsRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveAddFnsResponse() returns AddFnsResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <AddFnsResponse>payload;
        }
    }

    isolated remote function receiveContextAddFnsResponse() returns ContextAddFnsResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <AddFnsResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class ShowAllFnsResponseStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ShowAllFnsResponse value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if (streamValue is ()) {
            return streamValue;
        } else if (streamValue is grpc:Error) {
            return streamValue;
        } else {
            record {|ShowAllFnsResponse value;|} nextRecord = {value: <ShowAllFnsResponse>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public client class Show_all_with_criteriaStreamingClient {
    private grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendShowAllWithCritRequest(ShowAllWithCritRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextShowAllWithCritRequest(ContextShowAllWithCritRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveShowAllWithCritResponse() returns ShowAllWithCritResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return <ShowAllWithCritResponse>payload;
        }
    }

    isolated remote function receiveContextShowAllWithCritResponse() returns ContextShowAllWithCritResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <ShowAllWithCritResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public client class ReposityOfFunctionsAddFnsResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddFnsResponse(AddFnsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddFnsResponse(ContextAddFnsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ReposityOfFunctionsShowFnResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendShowFnResponse(ShowFnResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextShowFnResponse(ContextShowFnResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ReposityOfFunctionsDeleteFnResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendDeleteFnResponse(DeleteFnResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextDeleteFnResponse(ContextDeleteFnResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ReposityOfFunctionsShowAllFnsResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendShowAllFnsResponse(ShowAllFnsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextShowAllFnsResponse(ContextShowAllFnsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ReposityOfFunctionsAddFnResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddFnResponse(AddFnResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddFnResponse(ContextAddFnResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public client class ReposityOfFunctionsShowAllWithCritResponseCaller {
    private grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendShowAllWithCritResponse(ShowAllWithCritResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextShowAllWithCritResponse(ContextShowAllWithCritResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextShowAllFnsResponseStream record {|
    stream<ShowAllFnsResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextShowAllWithCritRequestStream record {|
    stream<ShowAllWithCritRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextShowAllWithCritResponseStream record {|
    stream<ShowAllWithCritResponse, error?> content;
    map<string|string[]> headers;
|};

public type ContextAddFnsRequestStream record {|
    stream<AddFnsRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextShowFnResponse record {|
    ShowFnResponse content;
    map<string|string[]> headers;
|};

public type ContextAddFnsResponse record {|
    AddFnsResponse content;
    map<string|string[]> headers;
|};

public type ContextDeleteFnRequest record {|
    DeleteFnRequest content;
    map<string|string[]> headers;
|};

public type ContextShowAllFnsResponse record {|
    ShowAllFnsResponse content;
    map<string|string[]> headers;
|};

public type ContextShowAllWithCritRequest record {|
    ShowAllWithCritRequest content;
    map<string|string[]> headers;
|};

public type ContextShowAllWithCritResponse record {|
    ShowAllWithCritResponse content;
    map<string|string[]> headers;
|};

public type ContextAddFnRequest record {|
    AddFnRequest content;
    map<string|string[]> headers;
|};

public type ContextShowAllFnsRequest record {|
    ShowAllFnsRequest content;
    map<string|string[]> headers;
|};

public type ContextAddFnResponse record {|
    AddFnResponse content;
    map<string|string[]> headers;
|};

public type ContextShowFnRequest record {|
    ShowFnRequest content;
    map<string|string[]> headers;
|};

public type ContextDeleteFnResponse record {|
    DeleteFnResponse content;
    map<string|string[]> headers;
|};

public type ContextAddFnsRequest record {|
    AddFnsRequest content;
    map<string|string[]> headers;
|};

public type ShowFnResponse record {|
    Func fn = {};
|};

public type AddFnsResponse record {|
    string[] funcNames = [];
|};

public type DeleteFnRequest record {|
    string funcName = "";
    int versionNum = 0;
|};

public type ShowAllWithCritResponse record {|
    Func[] fns = [];
|};

public type Func record {|
    string name = "";
    string lang = "";
    string[] keywords = [];
    string devName = "";
    string devEmail = "";
|};

public type AddFnRequest record {|
    Func fn = {};
|};

public type ShowAllFnsRequest record {|
    string funcName = "";
|};

public type AddFnResponse record {|
    string message = "";
|};

public type DeleteFnResponse record {|
    string message = "";
|};

public type AddFnsRequest record {|
    Func fn = {};
|};

public type ShowAllFnsResponse record {|
    Func fn = {};
|};

public type ShowAllWithCritRequest record {|
    string lang = "";
    string[] keywords = [];
|};

public type FuncVersion record {|
    int versionNum = 0;
    string fnDef = "";
|};

public type ShowFnRequest record {|
    string funcName = "";
    int versionNum = 0;
|};

const string ROOT_DESCRIPTOR = "0A1570726F746F636F6C5F6275666665722E70726F746F2280010A0446756E6312120A046E616D6518012001280952046E616D6512120A046C616E6718032001280952046C616E67121A0A086B6579776F72647318042003280952086B6579776F72647312180A076465764E616D6518052001280952076465764E616D65121A0A08646576456D61696C1806200128095208646576456D61696C22430A0B46756E6356657273696F6E121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D12140A05666E4465661807200128095205666E44656622250A0C416464466E5265717565737412150A02666E18012001280B32052E46756E635202666E22290A0D416464466E526573706F6E736512180A076D65737361676518012001280952076D65737361676522260A0D416464466E735265717565737412150A02666E18012001280B32052E46756E635202666E222E0A0E416464466E73526573706F6E7365121C0A0966756E634E616D6573180120032809520966756E634E616D6573224D0A0F44656C657465466E52657175657374121A0A0866756E634E616D65180120012809520866756E634E616D65121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D222C0A1044656C657465466E526573706F6E736512180A076D65737361676518012001280952076D657373616765224B0A0D53686F77466E52657175657374121A0A0866756E634E616D65180120012809520866756E634E616D65121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D22270A0E53686F77466E526573706F6E736512150A02666E18012001280B32052E46756E635202666E222F0A1153686F77416C6C466E7352657175657374121A0A0866756E634E616D65180120012809520866756E634E616D65222B0A1253686F77416C6C466E73526573706F6E736512150A02666E18012001280B32052E46756E635202666E22480A1653686F77416C6C57697468437269745265717565737412120A046C616E6718012001280952046C616E67121A0A086B6579776F72647318022003280952086B6579776F72647322320A1753686F77416C6C5769746843726974526573706F6E736512170A03666E7318012003280B32052E46756E635203666E7332DA020A135265706F736974794F6646756E6374696F6E73122B0A0A6164645F6E65775F666E120D2E416464466E526571756573741A0E2E416464466E526573706F6E7365122C0A076164645F666E73120E2E416464466E73526571756573741A0F2E416464466E73526573706F6E7365280112300A0964656C6574655F666E12102E44656C657465466E526571756573741A112E44656C657465466E526573706F6E7365122A0A0773686F775F666E120E2E53686F77466E526571756573741A0F2E53686F77466E526573706F6E736512390A0C73686F775F616C6C5F666E7312122E53686F77416C6C466E73526571756573741A132E53686F77416C6C466E73526573706F6E73653001124F0A1673686F775F616C6C5F776974685F637269746572696112172E53686F77416C6C5769746843726974526571756573741A182E53686F77416C6C5769746843726974526573706F6E736528013001620670726F746F33";

isolated function getDescriptorMap() returns map<string> {
    return {"protocol_buffer.proto": "0A1570726F746F636F6C5F6275666665722E70726F746F2280010A0446756E6312120A046E616D6518012001280952046E616D6512120A046C616E6718032001280952046C616E67121A0A086B6579776F72647318042003280952086B6579776F72647312180A076465764E616D6518052001280952076465764E616D65121A0A08646576456D61696C1806200128095208646576456D61696C22430A0B46756E6356657273696F6E121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D12140A05666E4465661807200128095205666E44656622250A0C416464466E5265717565737412150A02666E18012001280B32052E46756E635202666E22290A0D416464466E526573706F6E736512180A076D65737361676518012001280952076D65737361676522260A0D416464466E735265717565737412150A02666E18012001280B32052E46756E635202666E222E0A0E416464466E73526573706F6E7365121C0A0966756E634E616D6573180120032809520966756E634E616D6573224D0A0F44656C657465466E52657175657374121A0A0866756E634E616D65180120012809520866756E634E616D65121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D222C0A1044656C657465466E526573706F6E736512180A076D65737361676518012001280952076D657373616765224B0A0D53686F77466E52657175657374121A0A0866756E634E616D65180120012809520866756E634E616D65121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D22270A0E53686F77466E526573706F6E736512150A02666E18012001280B32052E46756E635202666E222F0A1153686F77416C6C466E7352657175657374121A0A0866756E634E616D65180120012809520866756E634E616D65222B0A1253686F77416C6C466E73526573706F6E736512150A02666E18012001280B32052E46756E635202666E22480A1653686F77416C6C57697468437269745265717565737412120A046C616E6718012001280952046C616E67121A0A086B6579776F72647318022003280952086B6579776F72647322320A1753686F77416C6C5769746843726974526573706F6E736512170A03666E7318012003280B32052E46756E635203666E7332DA020A135265706F736974794F6646756E6374696F6E73122B0A0A6164645F6E65775F666E120D2E416464466E526571756573741A0E2E416464466E526573706F6E7365122C0A076164645F666E73120E2E416464466E73526571756573741A0F2E416464466E73526573706F6E7365280112300A0964656C6574655F666E12102E44656C657465466E526571756573741A112E44656C657465466E526573706F6E7365122A0A0773686F775F666E120E2E53686F77466E526571756573741A0F2E53686F77466E526573706F6E736512390A0C73686F775F616C6C5F666E7312122E53686F77416C6C466E73526571756573741A132E53686F77416C6C466E73526573706F6E73653001124F0A1673686F775F616C6C5F776974685F637269746572696112172E53686F77416C6C5769746843726974526571756573741A182E53686F77416C6C5769746843726974526573706F6E736528013001620670726F746F33"};
}

