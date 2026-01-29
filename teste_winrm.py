import winrm

# Configuração da sessão
session = winrm.Session(
    '200.128.156.236',  # Substitua pelo IP/hostname
    auth=('Administrador', '!@sptCFT!@'),  # Usuário/senha do Windows
    transport='ntlm'  # ou 'kerberos' se em domínio AD
)

# Comando de teste (PowerShell)
result = session.run_ps('Get-Service WinRM')
print(result.status_code)  # 0 = sucesso
print(result.std_out.decode())  # Saída do comando
