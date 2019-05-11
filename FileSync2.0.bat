@echo oFF
title FileSync v2.0（文件同步/备份工具） - By:Flyfish
:: FileSync v2.0（文件同步/备份工具） - By:Flyfish
:: http://sec007.cc/7233.html
:: 测试环境：Windows 7 旗舰版 Ver6.1.7601 SP1 x64

CALL :Timevar
ECHO,
ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] 开始遍历磁盘...
ECHO,
IF DEFINED TARGET SET TARGET=
FOR /F "TOKENS=1 DELIMS=\ " %%I IN ('MOUNTVOL ^|FIND ":\"') DO (echo 发现磁盘%%I)
FOR /F "TOKENS=1 DELIMS=\ " %%A IN ('MOUNTVOL ^|FIND ":\"') DO (
    FOR /F "TOKENS=3 DELIMS= " %%B IN ('FSUTIL FSINFO VOLUMEINFO %%A^|find "卷序列号"') DO (
        if "%%B"=="0x7a20a4ff" (SET TARGET=%%A&echo,&ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] 检测目标磁盘“%%A”序列号与预设一致，即将开始文件同步/备份...&&GOTO FileSync)
    )
)


:FileSync
::文件保护
IF NOT DEFINED TARGET ECHO,&ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] 未发现与预设值相匹配目标磁盘!&ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] 程序退出.&ping 127.1>nul&exit /b 0
::if "%Defaultid%"=="0x58988ba5" (echo,&ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] 检测目标磁盘序列号与预设一致，即将开始文件同步/备份...) ELSE (echo,&ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] 未正确匹配目标磁盘卷标...&ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] 程序退出.&ping 127.1>nul&exit /b 0)
ECHO,
ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] Starting...
ECHO,
ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] “D:\NEW\”===^>^>“%TARGET%\NEW\”
ROBOCOPY D:\NEW\ %TARGET%\NEW\ /mir /MT:128 /BYTES /TS /FP /NP /NJH /NJS /TEE /LOG+:D:\NEW\Synlog.log
ECHO,
SET TARGET=
ECHO [%Timehh%:%time:~3,2%:%time:~6,2%] Finshed!&PING 127.1>NUL

:Timevar
SET Timehh=%time:~0,2%
IF /I %Timehh% LSS 10 (
SET Timehh=0%time:~1,1%
)
GOTO :EOF