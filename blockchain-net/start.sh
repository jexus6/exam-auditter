
#Para generar de nuevo crypto
#./artifacts/channel/create-artifacts.sh

docker-compose -f ./artifacts/docker-compose.yaml up -d

sleep 5
./createChannel.sh

sleep 2

./deployChaincodeExam.sh

sleep 20

docker-compose -f ./explorer/docker-compose.yaml up -d 
