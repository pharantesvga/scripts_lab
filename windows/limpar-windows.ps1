#Set-ExecutionPolicy RemoteSigned

# Caminho do perfil do usuário 'alunos'
$userProfile = "C:\Users\alunos"

# 1. Limpar a pasta Downloads
$downloads = "$userProfile\Downloads"
if (Test-Path $downloads) {
    Remove-Item "$downloads\*" -Recurse -Force -ErrorAction SilentlyContinue
}

# 2. Desabilitar hibernação
powercfg -h off

# 2.1 Limpar Temp Administrador
Remove-Item "C:\Users\ADMINI~1\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\Alunos\Documentos\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Users\Alunos\Imagens\*" -Recurse -Force -ErrorAction SilentlyContinue


#Disable-ComputerRestore -Drive "C:\"
#Remove-ComputerRestorePoint -ID 7


# 3. Alterar permissões e dono da pasta Roblox
$robloxPath = "$userProfile\AppData\Local\Roblox"

#caso tenha o jogo instalado, limpar a pasta antes
Remove-Item "$robloxPath\*" -Recurse -Force -ErrorAction SilentlyContinue

# Verifica se a pasta Roblox existe; se não, cria
if (-Not (Test-Path $robloxPath)) {
    New-Item -ItemType Directory -Path $robloxPath -Force | Out-Null
    Write-Output "Pasta Roblox criada em $robloxPath"
}


# Tomar posse da pasta
takeown /F $robloxPath /R /D Y

# Definir Administradores como proprietário
icacls $robloxPath /setowner "Administradores" /T

# Remove todas as permissões do usuário alunos
icacls $robloxPath /inheritance:r /T
icacls $robloxPath /remove:g alunos /T
icacls $robloxPath /deny alunos:F /T

# Garantir que Administradores tenham controle total
icacls $robloxPath /grant Administradores:F /T

Write-Output "Operação concluída."

# Limpar as Lixeiras

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

#ipconfig /renew

#shutdown /l
