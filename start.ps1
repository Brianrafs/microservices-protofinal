# run-all.ps1
# Script para rodar todos os microserviços

# Função auxiliar para rodar um script e tratar erros
function Run-Script($scriptPath) {
    if (Test-Path $scriptPath) {
        Write-Host "Executando $scriptPath ..." -ForegroundColor Cyan
        try {
            & $scriptPath
            if ($LASTEXITCODE -ne 0) {
                Write-Host "O script $scriptPath terminou com erro." -ForegroundColor Red
                exit $LASTEXITCODE
            }
        } catch {
            Write-Host "Falha ao executar $scriptPath" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Script $scriptPath não encontrado!" -ForegroundColor Red
        exit 1
    }
}

# Lista de scripts a serem executados
$scripts = @(
    "run-order.ps1",
    "run-payment.ps1",
    "run-shipping.ps1"
)

foreach ($script in $scripts) {
    Run-Script ".\$script"
}

Write-Host "Todos os scripts foram executados com sucesso!" -ForegroundColor Green
