@echo off
setlocal enabledelayedexpansion

:: 读取配置文件
call build_config.bat

:: 日志文件
set LOG_FILE=build_log.txt
if not exist "%LOG_FILE%" (
    >"%LOG_FILE%" echo 编译日志
)

:: ==============================
:: 单行快速编译模式
:: ==============================
if "%USE_SINGLE_LINE%"=="1" (
    echo [单行模式] 编译命令:
    echo %SINGLE_LINE_CMD%
    echo.
    %SINGLE_LINE_CMD%
    set RESULT=%ERRORLEVEL%
    set COMPILE_FLAGS=%SINGLE_LINE_CMD%
    goto :log_result
)

:: ==============================
:: 参数组合
:: ==============================
if /i "%BUILD_TYPE%"=="Release" (
    set COMPILE_FLAGS=%OPT_FLAGS% %PLATFORM_FLAGS% %SAFE_FLAGS% %LIBS%
) else (
    set COMPILE_FLAGS=%DEBUG_FLAGS% %PLATFORM_FLAGS% -fno-ident %LIBS%
)

:: ==============================
:: 控制台输出关键信息
:: ==============================
echo =========================================
echo 编译文件: %SRC_FILE%
echo 输出文件: %OUT_FILE%
echo 输出路径: %CD%\%OUT_FILE%
echo 编译模式: %BUILD_TYPE%
echo 编译参数: %COMPILE_FLAGS%
echo =========================================

:: ==============================
:: 编译执行
:: ==============================
gcc %SRC_FILE% -o %OUT_FILE% %COMPILE_FLAGS%
set RESULT=%ERRORLEVEL%

:: Release 模式额外安全处理
if "%BUILD_TYPE%"=="Release" if "%RESULT%"=="0" (
    strip --strip-all %OUT_FILE% >nul 2>&1
    objcopy --remove-section .comment %OUT_FILE% >nul 2>&1
    if "%USE_UPX%"=="1" (
        "%UPX_PATH%" %UPX_FLAGS% %OUT_FILE%
        >>"%LOG_FILE%" echo [UPX] 使用参数: %UPX_FLAGS%
        for %%I in (%OUT_FILE%) do >>"%LOG_FILE%" echo [UPX] 压缩后文件大小: %%~zI 字节
    )
)

:: ==============================
:: 记录详细日志
:: ==============================
:log_result
set "TIME_STR=%date% %time%"
>>"%LOG_FILE%" echo [时间] %TIME_STR%
>>"%LOG_FILE%" echo 模式: %BUILD_TYPE%
>>"%LOG_FILE%" echo 源文件: %SRC_FILE%
>>"%LOG_FILE%" echo 输出文件: %OUT_FILE%
>>"%LOG_FILE%" echo 输出路径: %CD%\%OUT_FILE%
>>"%LOG_FILE%" echo 编译参数: %COMPILE_FLAGS%
if "%RESULT%"=="0" (
    >>"%LOG_FILE%" echo 编译结果: 成功
    for %%I in (%OUT_FILE%) do >>"%LOG_FILE%" echo 文件大小: %%~zI 字节
) else (
    >>"%LOG_FILE%" echo 编译结果: 失败
)
>>"%LOG_FILE%" echo ------------------------------------------------------------

if "%RESULT%"=="0" (
    echo [成功] %OUT_FILE% 编译完成！
) else (
    echo [错误] 编译失败！
)

pause
endlocal
