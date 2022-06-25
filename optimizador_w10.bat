echo By: Airgold3#7061 & https://github.com/Airgold3/
@echo off

MODE con:cols=80 lines=40

echo  --> Verificando permisos
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

echo --> Si se establece el indicador de error, no tenemos administrador.
if '%errorlevel%' NEQ '0' (
    echo Solicitando privilegios administrativos...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

    echo Bienvenido al script de optimización de windows10
    pause 

    echo UTF8 en español
    chcp 65001

    echo Telemetría de Windows
    sc config DiagTrack start= disabled
    net stop "DiagTrack"

    echo Servicio WAP
    sc config dmwappushservice start= disabled
    net stop "dmwappushservice"

    echo Fax
    sc config fax start= disabled
    net stop "Fax"

    echo Mapas Descargados
    sc config MapsBroker start= disabled
    net stop "MapsBroker"

    echo Servicio de Red Xbox Live
    sc config XboxNetApiSvc start= disabled
    net stop "XboxNetApiSvc"

    echo Servicio de manejamiento de xbox
    sc config XboxGipSvc start= disabled
    net stop "XboxGipSvc"

    echo Servicio de manejamiento de xbox
    sc config XblGameSave start= disabled
    net stop "XblGameSave"

    timeout /t 3 /nobreak

    echo Desactivar otra gran parte de la Telemetría
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0

    echo Crear Carpeta para desactivar Cortana
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search"

    echo Desactivar Cortana
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0

    echo Crear Carpeta para desactivar Aplicaciones en segundo planos
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"

    echo Desactivar Aplicaciones en segundo plano
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2

    echo Quitar efectos de transparencia
    REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /f
    REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d 0

    echo Cambiar a modo oscuro
    REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /f
    REG ADD "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d 0

    echo Desactivar pantalla de bloqueo 
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization"
    REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreen" /t REG_DWORD /d 1

    echo Deshabilita el inicio rápido
    REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /V HiberbootEnabled /T REG_dWORD /D 0 /F

    timeout /t 3 /nobreak

    echo Deshabilitar Inicios del Programador de Treas sobre Telemetría
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
    schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable

    timeout /t 3 /nobreak

    echo Plan de alto rendimiento de energía 
    powercfg -import C:/energia.pow 7c21b0ce-a9d9-4961-b7da-d696e49dc373
    powercfg -setactive 7c21b0ce-a9d9-4961-b7da-d696e49dc373
    powercfg -changename 7c21b0ce-a9d9-4961-b7da-d696e49dc373 "Plan de energia de Alto Rendimiento" "Opciones de alto rendimiento para tu ordenador"
    
    set /p AREYOUSURE= Para ver los cambios hechos es necesario reiniciar el ordenador. ¿Desea reiniciar ahora? (S/N)?
    if %AREYOUSURE%==s (
        echo Eliminando optimizador_w10.bat...
        del /F /Q %HOMEDRIVE% optimizador_w10.bat
        shutdown /r /t 3
        )

    if %AREYOUSURE%==S (
        echo Eliminando optimizador_w10.bat...
        del /F /Q %HOMEDRIVE% optimizador_w10.bat
        shutdown /r /t 3
        )
    if %AREYOUSURE%==n (
        del /F /Q %HOMEDRIVE% optimizador_w10.bat
        exit 1
    )
    if %AREYOUSURE%==N  (
        del /F /Q %HOMEDRIVE% optimizador_w10.bat
        exit 1
    )
        




