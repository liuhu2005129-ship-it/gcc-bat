# 📋 API 参考手册

## build_config.bat 完整参考

### 基本配置

#### 1. SRC_FILE - 源文件

**说明**: 要编译的 C 源文件

**默认值**: `main.c`

**用法**:
```batch
set SRC_FILE=main.c
```

**示例**:
```batch
:: 单个文件
set SRC_FILE=program.c

:: 多个文件
set SRC_FILE=main.c utils.c math.c helper.c

:: 完整路径
set SRC_FILE=C:\projects\src\main.c

:: 通配符（某些 GCC 版本支持）
set SRC_FILE=*.c
```

---

#### 2. OUT_FILE - 输出文件

**说明**: 编译后生成的可执行文件名

**默认值**: `AppRelease.exe`

**用法**:
```batch
set OUT_FILE=myapp.exe
```

**示例**:
```batch
:: 简单名称
set OUT_FILE=program.exe

:: 带版本号
set OUT_FILE=app_v1.0.exe

:: 带路径
set OUT_FILE=C:\bin\myapp.exe

:: 无扩展名（GCC 会自动添加 .exe）
set OUT_FILE=myapp
```

---

#### 3. BUILD_TYPE - 编译模式

**说明**: 选择编译优化策略

**默认值**: `Release`

**用法**:
```batch
set BUILD_TYPE=Release
```

**可选值**:

| 值 | 说明 | 优化 | 调试 | 文件大小 |
|-----|------|------|------|---------|
| Release | 生产发布 | ✅ 极高 | ❌ 无 | ✅ 小 |
| Debug | 调试开发 | ❌ 无 | ✅ 完全 | ❌ 大 |

---

### 优化参数

#### 4. OPT_FLAGS - 优化选项

**说明**: Release 模式下的编译优化参数

**默认值**: `-O3 -march=native -flto -fomit-frame-pointer -pipe`

**GCC 优化级别**:

| 选项 | 等级 | 速度 | 体积 | 编译时间 | 说明 |
|------|------|------|------|---------|------|
| -O0 | 无 | 慢 | 大 | 快 | 无优化（调试用） |
| -O1 | 低 | 快 | 中 | 中 | 基础优化 |
| -O2 | 中 | 快 | 小 | 长 | 平衡优化（推荐） |
| -O3 | 高 | 最快 | 小 | 很长 | 激进优化 |
| -Os | 小 | 较快 | 最小 | 中 | 体积优化 |
| -Ofast | 极 | 最快 | 中 | 极长 | 忽略标准，最快 |

**架构优化**:

| 选项 | 说明 |
|------|------|
| -march=native | 针对本地 CPU（最快，可能不兼容） |
| -march=x86-64 | 通用 x86-64（兼容性好） |
| -march=i686 | 32 位 x86（旧系统） |
| -march=core2 | Intel Core 2 系列 |
| -march=haswell | 较新的 Intel CPU |
| -march=znver2 | AMD Ryzen 系列 |

**高级优化**:

| 选项 | 说明 | 风险 |
|------|------|------|
| -flto | 链接时优化（全程序） | ⭐ 低 |
| -fomit-frame-pointer | 消除帧指针 | ⭐ 低 |
| -funroll-loops | 循环展开 | ⭐ 低 |
| -fpredictive-commoning | 预测性交换 | ⭐ 中 |
| -fmodulo-sched | 模调度 | ⭐⭐ 高 |
| -funsafe-math-optimizations | 不安全数学优化 | ⭐⭐⭐ 极高 |

**推荐组合**:

```batch
:: 平衡（推荐用于大多数应用）
set OPT_FLAGS=-O2 -march=native -flto

:: 极速（服务器/计算密集型）
set OPT_FLAGS=-O3 -march=native -flto -fomit-frame-pointer -funroll-loops

:: 极小（嵌入式/体积敏感）
set OPT_FLAGS=-Os -march=i586

:: 兼容性优先（跨平台）
set OPT_FLAGS=-O2 -march=x86-64

:: 保守（最稳定）
set OPT_FLAGS=-O2
```

---

#### 5. DEBUG_FLAGS - 调试选项

**说明**: Debug 模式下的编译参数

**默认值**: `-O0 -g`

**常用选项**:

| 选项 | 说明 |
|------|------|
| -O0 | 无优化（便于调试） |
| -g | 包含基础调试信息 |
| -g3 | 包含详细调试信息（包括宏） |
| -ggdb | 针对 GDB 的调试信息 |
| -fno-inline | 禁用内联（调试更清晰） |
| -fno-optimize-sibling-calls | 禁用尾调用优化 |

**推荐配置**:
```batch
:: 基础调试
set DEBUG_FLAGS=-O0 -g

:: 详细调试（推荐）
set DEBUG_FLAGS=-O0 -g3 -fno-inline

:: GDB 专用
set DEBUG_FLAGS=-O0 -ggdb3 -fno-inline
```

---

### 平台和安全选项

#### 6. PLATFORM_FLAGS - 平台选项

**说明**: Windows 特定的编译选项

**默认值**: `-mwindows -municode`

| 选项 | 说明 | 用途 |
|------|------|------|
| -mwindows | 图形界面应用 | GUI 程序（无控制台窗口） |
| -mconsole | 控制台应用 | 默认，显示控制台 |
| -municode | Unicode 主函数 | Windows 默认推荐 |
| -m32 | 32 位编译 | 兼容旧系统 |
| -m64 | 64 位编译 | 默认（大多数现代系统） |

**常见组合**:
```batch
:: GUI 程序（推荐）
set PLATFORM_FLAGS=-mwindows -municode

:: 控制台程序
set PLATFORM_FLAGS=-mconsole -municode

:: 32 位兼容
set PLATFORM_FLAGS=-m32 -municode

:: 纯 64 位
set PLATFORM_FLAGS=-m64
```

---

#### 7. SAFE_FLAGS - 安全选项

**说明**: Release 模式下的安全和隐藏选项

**默认值**: `-s -fno-ident -Wl,--strip-all -Wl,--build-id=none`

| 选项 | 说明 | 效果 |
|------|------|------|
| -s | 去除符号表 | 隐藏调试信息，减小 30-50% |
| -fno-ident | 去编译器信息 | 隐藏 GCC 版本 |
| -Wl,--strip-all | 链接���去符号 | 更彻底的符号移除 |
| -Wl,--build-id=none | 移除 build ID | 进一步减小体积 |
| -fdata-sections | 分离数据段 | 便于链接器优化 |
| -ffunction-sections | 分离函数段 | 便于链接器优化 |
| -Wl,--gc-sections | 垃圾回收段 | 移除未使用代码 |

**推荐配置**:
```batch
:: 标准安全
set SAFE_FLAGS=-s -fno-ident

:: 完全隐藏（推荐）
set SAFE_FLAGS=-s -fno-ident -Wl,--strip-all -fdata-sections -ffunction-sections -Wl,--gc-sections

:: 最大隐藏
set SAFE_FLAGS=-s -fno-ident -Wl,--strip-all -Wl,--build-id=none -fdata-sections -ffunction-sections -Wl,--gc-sections
```

---

### 链接库

#### 8. LIBS - 链接库

**说明**: 要链接的系统库和第三方库

**默认值**: `-lgdi32 -lcomctl32 -lcomdlg32 -lmsimg32`

**Windows 标准库**:

| 库 | 功能 | 使用场景 |
|-----|------|---------|
| -luser32 | 用户界面 | 窗口、消息框 |
| -lgdi32 | 图形输出 | 绘图、文字 |
| -lcomctl32 | 通用控件 | 按钮、列表框 |
| -lcomdlg32 | 通用对话框 | 文件选择、打印 |
| -lmsimg32 | 图像处理 | 图像函数 |
| -lws2_32 | 网络套接字 | TCP/UDP 通信 |
| -lwsock32 | 原始套接字 | 低级网络 |
| -lole32 | COM 接口 | 对象链接嵌入 |
| -loleaut32 | OLE 自动化 | 自动化接口 |
| -ladvapi32 | 高级 API | 注册表、安全 |
| -lshell32 | 外壳接口 | 文件操作 |
| -lversion | 版本信息 | 文件版本 |

**标准 C 库**:
```batch
:: 自动链接（无需显式添加）
-lc          :: C 标准库
-lm          :: 数学库
-lpthread    :: POSIX 线程
-lstdc++     :: C++ 标准库（g++ 自动）
```

**常见库组合**:

```batch
:: GUI 应用（推荐）
set LIBS=-luser32 -lgdi32 -lcomctl32 -lcomdlg32 -lmsimg32

:: 网络应用
set LIBS=-lws2_32 -lwinmm -liphlpapi

:: 系统工具
set LIBS=-ladvapi32 -lshell32 -lversion

:: 最小依赖
set LIBS=

:: 完整 Windows API
set LIBS=-luser32 -lgdi32 -lcomctl32 -lcomdlg32 -lmsimg32 -lws2_32 -ladvapi32 -lshell32 -lole32 -loleaut32
```

---

### 高级选项

#### 9. USE_SINGLE_LINE - 单行编译

**说明**: 启用单行快速编译模式

**默认值**: `0`

**说明**:
- 0 = 禁用（使用模块化参数组合）
- 1 = 启用（使用完整单行命令）

**用途**: 快速验证自定义编译命令

```batch
set USE_SINGLE_LINE=1
set SINGLE_LINE_CMD=gcc main.c -o app.exe -O3 -march=native -flto -mwindows -municode -s
```

---

#### 10. SINGLE_LINE_CMD - 单行编译命令

**说明**: 完整的编译命令（仅在 USE_SINGLE_LINE=1 时使用）

**默认值**: (示例命令)

**格式**:
```batch
set SINGLE_LINE_CMD=gcc [源文件] -o [输出文件] [所有选项]
```

**示例**:
```batch
:: 简单程序
set SINGLE_LINE_CMD=gcc main.c -o app.exe -O2 -Wall

:: 复杂程序
set SINGLE_LINE_CMD=gcc main.c utils.c -o app.exe -O3 -march=native -flto -mwindows -lgdi32 -lws2_32

:: 调试版本
set SINGLE_LINE_CMD=gcc main.c -o app_debug.exe -O0 -g -Wall -Wextra
```

---

#### 11. USE_UPX - UPX 压缩

**说明**: 启用 UPX 可执行文件压缩

**默认值**: `0`

**说明**:
- 0 = 禁用（不压缩）
- 1 = 启用（压缩可执行文件）

**用途**: 进一步减小文件体积（额外压缩 50-80%）

```batch
set USE_UPX=1
```

---

#### 12. UPX_PATH - UPX 路径

**说明**: UPX 程序的完整路径

**默认值**: `D:\Program\upx\upx.exe`

**用法**:
```batch
set "UPX_PATH=C:\tools\upx\upx.exe"
```

**获取 UPX**: https://upx.github.io/

---

#### 13. UPX_FLAGS - UPX 选项

**说明**: UPX 压缩的选项

**默认值**: `--best --lzma`

| 选项 | 说明 | 压缩率 | 速度 |
|------|------|--------|------|
| --fast | 快速压缩 | 中 | 快 |
| --best | 最佳压缩 | 高 | 慢 |
| --lzma | LZMA 算法 | 最高 | 最慢 |
| --ultra-brute | 极限压缩 | 极高 | 极慢 |

**推荐组合**:
```batch
:: 平衡（推荐）
set UPX_FLAGS=--best

:: 最小体积
set UPX_FLAGS=--best --lzma

:: 快速压缩
set UPX_FLAGS=--fast

:: 极限压缩（可能很慢）
set UPX_FLAGS=--best --lzma --ultra-brute
```

---

## GCC 编译器选项分类

### 警告选项

```batch
-Wall              :: 启用常见警告
-Wextra            :: 启用额外警告
-Werror            :: 将警告视为错误
-Wno-unused        :: 忽略未使用警告
-pedantic          :: 严格遵守 C 标准
```

### 代码生成选项

```batch
-static            :: 静态链接所有库
-static-libgcc     :: 静态链接 libgcc
-static-libstdc++  :: 静态链接 libstdc++
-fPIC              :: 位置独立代码
-fPIE              :: 位置独立可执行文件
```

### 预处理选项

```batch
-DNAME             :: 定义宏
-DNAME=value       :: 定义宏值
-Ipath             :: 包含路径
-E                 :: 仅预处理
```

### 输出选项

```batch
-v                 :: 详细输出
-c                 :: 编译不链接（生成 .o）
-S                 :: 生成汇编代码
-E                 :: 生成预处理代码
```

---

## 预设配置方案

### 方案 1：标准 Release（推荐）

```batch
set BUILD_TYPE=Release
set OPT_FLAGS=-O2 -march=native -flto
set PLATFORM_FLAGS=-mwindows -municode
set SAFE_FLAGS=-s -fno-ident
set LIBS=-lgdi32 -lcomctl32
```

### 方案 2：极速优化

```batch
set BUILD_TYPE=Release
set OPT_FLAGS=-O3 -march=native -flto -fomit-frame-pointer -funroll-loops -fpredictive-commoning
set PLATFORM_FLAGS=-mwindows -municode
set SAFE_FLAGS=-s -fno-ident -Wl,--strip-all
set LIBS=-lgdi32 -lcomctl32
set USE_UPX=1
```

### 方案 3：极小体积

```batch
set BUILD_TYPE=Release
set OPT_FLAGS=-Os -march=i586
set PLATFORM_FLAGS=-mwindows
set SAFE_FLAGS=-s -fno-ident -Wl,--strip-all
set LIBS=-lkernel32
set USE_UPX=1
set UPX_FLAGS=--best --lzma
```

### 方案 4：调试开发

```batch
set BUILD_TYPE=Debug
set OPT_FLAGS=-O0
set DEBUG_FLAGS=-O0 -g3 -fno-inline
set PLATFORM_FLAGS=-mconsole -municode
set LIBS=-lgdi32 -lcomctl32
```

### 方案 5：兼容性优先

```batch
set BUILD_TYPE=Release
set OPT_FLAGS=-O2 -march=x86-64
set PLATFORM_FLAGS=-m32 -municode
set SAFE_FLAGS=-s
set LIBS=-lgdi32 -lcomctl32
```

### 方案 6：嵌入式系统

```batch
set BUILD_TYPE=Release
set OPT_FLAGS=-Os -march=armv7-a -flto
set PLATFORM_FLAGS=
set SAFE_FLAGS=-s
set LIBS=
```

### 方案 7：网络应用

```batch
set BUILD_TYPE=Release
set OPT_FLAGS=-O3 -march=native -flto -pthread
set PLATFORM_FLAGS=-mconsole
set SAFE_FLAGS=-s -fno-ident
set LIBS=-lws2_32 -lwsock32 -lpthread
```

### 方案 8：保守编译

```batch
set BUILD_TYPE=Release
set OPT_FLAGS=-O2
set PLATFORM_FLAGS=-mwindows
set SAFE_FLAGS=-s
set LIBS=-lgdi32 -lcomctl32
```

---

## 参数对比速查表

| 需求 | 配置 | 文件大小 | 速度 | 调试 |
|------|------|---------|------|------|
| 快速开发 | Debug | 大 | 慢 | ✅ |
| 最终发布 | Release | 小 | 快 | ❌ |
| 极限性能 | -O3 极速 | 中 | 最快 | ❌ |
| 最小体积 | -Os UPX | 最小 | 较快 | ❌ |
| 跨平台 | -march=x86-64 | 小 | 较快 | ❌ |
| 向后兼容 | -march=i586 | 中 | 慢 | ❌ |

---

**参考手册版本**: 1.0  
**最后更新**: 2026-04-29
