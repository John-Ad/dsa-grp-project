bal openapi -i ./open_api/open_api.yaml
rm ./client/client.bal
mv ./client.bal ./client/client.bal
mv ./open_api_service.bal ./service/open_api_service_temp.bal
rm ./client/types.bal
rm ./service/types.bal
cp ./types.bal ./client/types.bal
cp ./types.bal ./service/types.bal
rm ./types.bal
echo done...