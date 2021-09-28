rm -rf ./service_temp
rm -rf ./client_temp
bal grpc --input protocol_buffer/protocol_buffer.proto --mode service --output ./service_temp
bal grpc --input protocol_buffer/protocol_buffer.proto --mode client --output ./client_temp
mv ./service_temp/protocol_buffer_pb.bal ./service/proto_buffer_pb.bal
mv ./client_temp/protocol_buffer_pb.bal ./client/proto_buffer_pb.bal
rm -rf ./service_temp
rm -rf ./client_temp