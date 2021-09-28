bal openapi -i ./open_api/open_api.yaml

rm ./client/client.bal
mv ./client.bal ./client/client.bal

mv ./open_api_service.bal ./server/open_api_service_temp.bal

rm ./client/types.bal
rm ./server/types.bal
cp ./types.bal ./client/types.bal
cp ./types.bal ./server/types.bal
rm ./types.bal

echo done...