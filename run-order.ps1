# --- Variáveis de Configuração ---
$GITHUB_USERNAME = "brianrafs"
$SERVICE_NAME = "order"

# --- Preparação do Ambiente ---
Write-Host "Instalando ferramentas do Go Protobuf..." -ForegroundColor Cyan
# Este comando funciona igual no Windows e no Linux
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# Adiciona o diretório bin do GoPath ao PATH desta sessão do terminal.
# PowerShell usa '; ' como separador de PATH, e a variável de ambiente é $env:Path
$goPathBin = Join-Path (go env GOPATH) "bin"
$env:Path += ";$goPathBin"
Write-Host "Caminho do Go ('$goPathBin') adicionado ao PATH temporariamente." -ForegroundColor Green

# Adiciona o caminho do protoc manualmente (ajuste se necessário)
$protocPath = "C:\Users\Administrator\Downloads\Protoc\bin"
$env:Path += ";$protocPath"
Write-Host "Caminho do protoc ('$protocPath') adicionado ao PATH temporariamente." -ForegroundColor Green


# --- Geração dos Arquivos a partir do .proto ---
Write-Host "Gerando código-fonte Go a partir dos arquivos .proto..." -ForegroundColor Cyan

# Cria o diretório 'golang', se não existir. O '-Force' evita erro se a pasta já existir.
New-Item -ItemType Directory -Path "golang" -Force | Out-Null


$protoFile = "./${SERVICE_NAME}/${SERVICE_NAME}.proto"
if (-Not (Test-Path $protoFile)) {
    Write-Host "Arquivo $protoFile não encontrado!" -ForegroundColor Red
    exit 1
}

protoc --go_out=./golang `
--go_opt=paths=source_relative `
--go-grpc_out=./golang `
--go-grpc_opt=paths=source_relative `
./${SERVICE_NAME}/order.proto

Write-Host "Arquivos Go gerados com sucesso!" -ForegroundColor Green
Get-ChildItem -Path "./golang/$SERVICE_NAME" # Equivalente ao 'ls -al'


# --- Configuração do Módulo Go ---
Write-Host "Inicializando o módulo Go..." -ForegroundColor Cyan


Set-Location -Path "./golang/$SERVICE_NAME"


go mod init "github.com/$GITHUB_USERNAME/microservices-protofinal/golang/$SERVICE_NAME"
go mod tidy

Write-Host "Módulo Go configurado em $(Get-Location)." -ForegroundColor Green


Set-Location ../../