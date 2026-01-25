@echo off
REM Real-time Resource Monitor for Development
REM Monitors CPU, RAM, disk during compilation

setlocal enabledelayedexpansion

echo ========================================
echo   Development Resource Monitor
echo ========================================
echo.
echo Press Ctrl+C to exit
echo.

:monitor_loop
cls
echo ========================================
echo   System Resources - %date% %time%
echo ========================================
echo.

REM CPU Usage
for /f "skip=1 delims=" %%p in ('wmic cpu get loadpercentage') do (
    set CPU=%%p
    goto :cpu_done
)
:cpu_done
set CPU=%CPU:~0,-1%
echo [CPU] Usage: %CPU%%%

REM Memory Usage
for /f "skip=1" %%p in ('wmic OS get FreePhysicalMemory') do (
    set FREE_MEM=%%p
    goto :mem_done
)
:mem_done
for /f "skip=1" %%p in ('wmic OS get TotalVisibleMemorySize') do (
    set TOTAL_MEM=%%p
    goto :total_mem_done
)
:total_mem_done
set /a USED_MEM=%TOTAL_MEM%-%FREE_MEM%
set /a MEM_PERCENT=(%USED_MEM%*100)/%TOTAL_MEM%
set /a USED_GB=%USED_MEM%/1024/1024
set /a TOTAL_GB=%TOTAL_MEM%/1024/1024
echo [RAM] Usage: %MEM_PERCENT%%% (%USED_GB%GB / %TOTAL_GB%GB)

REM Disk Usage
for /f "tokens=3" %%a in ('dir C:\ ^| find "bytes free"') do set FREE_DISK=%%a
set FREE_DISK=%FREE_DISK:,=%
set /a FREE_DISK_GB=%FREE_DISK%/1073741824
echo [DISK] C:\ Free: %FREE_DISK_GB%GB

echo.
echo [PROCESSES] Top CPU Consumers:
wmic path Win32_PerfFormattedData_PerfProc_Process where "Name!='_Total' and Name!='Idle'" get Name,PercentProcessorTime | sort /r | find /v "0" | more +1

echo.
echo Refreshing in 5 seconds...
timeout /t 5 /nobreak >nul
goto :monitor_loop
