@echo off

::::::::: 配置 :::::::::
:: 设置你的ESP-IDF项目根目录（或作为参数传入）,不能有空格
set PROJECT_PATH=D:\esp32_8266_files\esp-idf-v5.3.1_ol\examples\yjt_HL0_V3\Device_Ctrl_YJT
:: 默认串口号和波特率
@REM set DEFAULT_COM=COM8
set DEFAULT_COM=COM7
set DEFAULT_FBPS=460800
set DEFAULT_FBPS=2000000
@REM set DEFAULT_FBPS=20000000
set DEFAULT_MBPS=115200
::::::::: 配置 :::::::::

:: 检查是否传入了参数
if "%~1"=="" (
    call :usage
    exit /b 1
)

:::::::::::::::::::::::::::::::::::::::::::::
:: 判断参数并调用对应函数
:::::::::::::::::::::::::::::::::::::::::::::

if /i "%~1"=="build" (
    call :build
) else if /i "%~1"=="menuconfig" (
    call :menuconfig
) else if /i "%~1"=="clean" (
    call :clean
) else if /i "%~1"=="fullclean" (
    call :fullclean
) else if /i "%~1"=="size" (
    call :size
) else if /i "%~1"=="size-components" (
    call :size_components
) else if /i "%~1"=="size-files" (
    call :size_files
) else if /i "%~1"=="partition-table" (
    call :partition_table
) else if /i "%~1"=="reconfigure" (
    call :reconfigure
) else if /i "%~1"=="set-target" (
    if "%~2"=="" (
        echo Error: Target not specified.
        call :usage_set_target
        exit /b 1
    )
    call :set_target %~2
) else if /i "%~1"=="flash" (
    if "%~2"=="" (
        echo Using default port: %DEFAULT_COM%, baud rate: %DEFAULT_FBPS%
        call :flash %DEFAULT_COM% %DEFAULT_FBPS%
    ) else (
        call :flash %~2 %DEFAULT_FBPS%
    )
) else if /i "%~1"=="app_flash" (
    if "%~2"=="" (
        echo Using default port: %DEFAULT_COM%, baud rate: %DEFAULT_FBPS%
        call :app_flash %DEFAULT_COM% %DEFAULT_FBPS%
    ) else (
        call :app_flash %~2 %DEFAULT_FBPS%
    )
) else if /i "%~1"=="monitor" (
    if "%~2"=="" (
        echo Using default port: %DEFAULT_COM%, baud rate: %DEFAULT_MBPS%
        call :monitor %DEFAULT_COM% %DEFAULT_MBPS%
    ) else (
        call :monitor %~2 %DEFAULT_MBPS%
    )
) else if /i "%~1"=="flash_monitor" (
    if "%~2"=="" (
        echo Using default port: %DEFAULT_COM%, flash baud: %DEFAULT_FBPS%, monitor baud: %DEFAULT_MBPS%
        call :flash_monitor %DEFAULT_COM% %DEFAULT_FBPS% %DEFAULT_MBPS%
    ) else (
        call :flash_monitor %~2 %DEFAULT_FBPS% %DEFAULT_MBPS%
    )
) else if /i "%~1"=="app_flash_monitor" (
    if "%~2"=="" (
        echo Using default port: %DEFAULT_COM%, flash baud: %DEFAULT_FBPS%, monitor baud: %DEFAULT_MBPS%
        call :app_flash_monitor %DEFAULT_COM% %DEFAULT_FBPS% %DEFAULT_MBPS%
    ) else (
        call :app_flash_monitor %~2 %DEFAULT_FBPS% %DEFAULT_MBPS%
    )
) else (
    echo Invalid command: %~1
    call :usage
    exit /b 1
)

exit /b 0

::::::::::::::::::::::::::::::::::
:: 函数定义开始
::::::::::::::::::::::::::::::::::

:usage
    echo Usage: %0 [command]
    echo Commands:
    echo   build
    echo   menuconfig
    echo   clean
    echo   fullclean
    echo   size
    echo   size-components
    echo   size-files
    echo   reconfigure
    echo   set-target ^<target^>
    echo   flash [port]  ^<-- Flash firmware with optional port, using default baud rate if not provided^>
    echo   monitor [port]  ^<-- Monitor serial output with optional port, using default baud rate if not provided^>
    echo   flash_monitor [port]  ^<-- Flash and then monitor with optional port, using default baud rates if not provided^>
    exit /b

:usage_set_target
    echo Usage: %0 set-target ^<target^>
    echo Example: %0 set-target esp32s3
    exit /b

::::::::::::::::::::::::::::::::::
:: 各个命令实现（使用 -C 指定项目目录）
::::::::::::::::::::::::::::::::::

:build
    echo Start building the project...
    idf.py -C "%PROJECT_PATH%" build
    exit /b 0

:menuconfig
    echo Open the menuconfig configuration screen...
    idf.py -C "%PROJECT_PATH%" menuconfig
    exit /b 0

:clean
    echo Cleaning the build files...
    idf.py -C "%PROJECT_PATH%" clean
    exit /b 0

:fullclean
    echo Full cleaning (distclean) the project...
    idf.py -C "%PROJECT_PATH%" fullclean
    exit /b 0

:size
    echo Showing overall firmware size...
    idf.py -C "%PROJECT_PATH%" size
    exit /b 0

:size_components
    echo Showing component-wise firmware size...
    idf.py -C "%PROJECT_PATH%" size-components
    exit /b 0

:size_files
    echo Showing file-level firmware size...
    idf.py -C "%PROJECT_PATH%" size-files
    exit /b 0

:partition_table
    echo Displaying partition table...
    idf.py -C "%PROJECT_PATH%" partition-table
    exit /b 0

:reconfigure
    echo Reconfiguring the project with CMake...
    idf.py -C "%PROJECT_PATH%" reconfigure
    exit /b 0

:set_target
    echo Setting target to: %~1
    idf.py -C "%PROJECT_PATH%" set-target %~1
    exit /b 0

:flash
    echo Flashing to device on port: %~1 at baud rate: %~2
    idf.py -C "%PROJECT_PATH%" flash -p %~1 -b %~2
    exit /b 0

:app_flash
    echo app Flashing to device on port: %~1 at baud rate: %~2
    idf.py -C "%PROJECT_PATH%" app-flash -p %~1 -b %~2
    exit /b 0

:monitor
    echo Starting monitor on port: %~1 at baud rate: %~2
    idf.py -C "%PROJECT_PATH%" monitor -p %~1 -b %~2
    exit /b 0

:flash_monitor
    echo Flashing to device on port: %~1 at baud rate: %~2
    idf.py -C "%PROJECT_PATH%" flash -p %~1 -b %~2
    echo Starting monitor at baud rate: %~3
    idf.py -C "%PROJECT_PATH%" monitor -p %~1 -b %~3
    exit /b 0

:app_flash_monitor
    echo Flashing app to device on port: %~1 at baud rate: %~2
    idf.py -C "%PROJECT_PATH%" app-flash -p %~1 -b %~2
    echo Starting monitor at baud rate: %~3
    idf.py -C "%PROJECT_PATH%" monitor -p %~1 -b %~3
    exit /b 0