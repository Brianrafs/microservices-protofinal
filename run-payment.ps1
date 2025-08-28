$SERVICE_NAME = "payment"


New-Item -ItemType Directory -Path "golang\$SERVICE_NAME" -Force | Out-Null

$protoFile = ".\$SERVICE_NAME\$SERVICE_NAME.proto"
if (-Not (Test-Path $protoFile)) {
    Write-Host "Arquivo $protoFile não encontrado!" -ForegroundColor Red
    exit 1
}

protoc --go_out=./golang/$SERVICE_NAME `
       --go_opt=paths=source_relative `
       --go-grpc_out=./golang/$SERVICE_NAME `
       --go-grpc_opt=paths=source_relative `
       $protoFile

Write-Host "Arquivos Go gerados em ./golang/$SERVICE_NAME" -ForegroundColor Green