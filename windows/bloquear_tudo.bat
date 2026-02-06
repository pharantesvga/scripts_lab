@echo off
:: Script para BLOQUEAR TODAS as personalizações no Windows 10 Pro
:: Deve ser executado como Administrador

set "usuario=Alunos"  :: Nome do usuário a ser restringido
set "wallpaper_path=C:\scripts\wallpaper.jpeg"

:: Verifica se está sendo executado como administrador
net session >nul 2>&1 || (
    echo [ERRO] Execute como Administrador.
    pause
    exit /b
)

:: Verifica se o wallpaper existe
if not exist "%wallpaper_path%" (
    echo [AVISO] Arquivo não encontrado: %wallpaper_path%
    echo Crie a pasta "C:\scripts" e coloque "wallpaper.jpg" lá.
    pause
    exit /b
)

:::::::::::::::::::::::::::::::::
:: 1. BLOQUEAR PAPEL DE PAREDE E PERSONALIZAÇÃO
:::::::::::::::::::::::::::::::::
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "Wallpaper" /t REG_SZ /d "%wallpaper_path%" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "WallpaperStyle" /t REG_SZ /d "2" /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /v "NoChangingWallpaper" /t REG_DWORD /d 1 /f

:::::::::::::::::::::::::::::::::
:: 2. BLOQUEAR CORES, TEMAS, ÍCONES E MENU INICIAR
:::::::::::::::::::::::::::::::::
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoThemesTab" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoColorChoice" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoVisualStyleChoice" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoChangingWallpaper" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f

:::::::::::::::::::::::::::::::::
:: 3. BLOQUEAR BARRA DE TAREFAS E MENU INICIAR
:::::::::::::::::::::::::::::::::
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCloseDragDropBands" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoMovingBands" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSetTaskbar" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoTrayContextMenu" /t REG_DWORD /d 1 /f

:::::::::::::::::::::::::::::::::
:: 4. BLOQUEAR ACESSO AO MENU DE PERSONALIZAÇÃO
:::::::::::::::::::::::::::::::::
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoControlPanel" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoSettingsPage" /t REG_DWORD /d 1 /f

:::::::::::::::::::::::::::::::::
:: 5. APLICAR PARA O USUÁRIO ALUNO (CARREGANDO HIVE)
:::::::::::::::::::::::::::::::::
reg load "HKU\%usuario%_temp" "C:\Users\%usuario%\NTUSER.DAT" >nul 2>&1 && (
    reg copy "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" "HKU\%usuario%_temp\Software\Microsoft\Windows\CurrentVersion\Policies" /s /f
    reg unload "HKU\%usuario%_temp"
)

:::::::::::::::::::::::::::::::::::::::::::::::
:: 6. APAGANDO regras do usuário Administrador
:::::::::::::::::::::::::::::::::::::::::::::::
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop" /f

::gpupdate /force
::taskkill /f /im explorer.exe >nul
::start explorer.exe

echo [SUCESSO] Todas as personalizações foram bloqueadas para o usuário "%usuario%".
echo - Papel de parede | Cores | Temas | Barra de Tarefas | Menu Iniciar | Painel de Controle
pause
