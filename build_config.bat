:: ==============================
:: 编译配置文件
:: ==============================

:: 源文件
set SRC_FILE=main.c

:: 输出文件
set OUT_FILE=AppRelease.exe

:: 编译模式（Release / Debug）
set BUILD_TYPE=Release

:: 优化参数
set OPT_FLAGS=-O3 -march=native -flto -fomit-frame-pointer -pipe
set DEBUG_FLAGS=-O0 -g

:: 平台参数
set PLATFORM_FLAGS=-mwindows -municode

:: 安全优化参数（Release）
set SAFE_FLAGS=-s -fno-ident -Wl,--strip-all -Wl,--build-id=none

:: 链接库
set LIBS=-lgdi32 -lcomctl32 -lcomdlg32 -lmsimg32

:: 是否使用单行快速编译（1=启用，0=禁用）
set USE_SINGLE_LINE=0

:: 单行快速编译命令（仅在 USE_SINGLE_LINE=1 时生效）
set SINGLE_LINE_CMD=gcc main.c -o AppRelease.exe -O3 -march=native -flto -fomit-frame-pointer -pipe -mwindows -municode -s -fno-ident -Wl,--strip-all -Wl,--build-id=none -lgdi32 -lcomctl32 -lcomdlg32 -lmsimg32

:: 是否使用 UPX 压缩（Release 可选）-USE_UPX=1 → 开启压缩
set "UPX_PATH=D:\Program\upx\upx.exe"
set USE_UPX=0
set UPX_FLAGS=--best --lzma
