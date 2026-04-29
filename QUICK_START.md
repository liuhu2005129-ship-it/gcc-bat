# ⚡ 快速入门指南

## 5 分钟快速开始

### 前置条件

**验证 GCC 已安装**:
```cmd
gcc --version
```

如果出现版本信息，说明已安装。否则请先安装 MinGW：https://www.mingw-w64.org/

### 4 个快速步骤

#### 1️⃣ 准备源文件

创建 `main.c`：
```c
#include <stdio.h>

int main() {
    printf("Hello, GCC-BAT!\n");
    return 0;
}
```

#### 2️⃣ 配置编译参数

编辑 `build_config.bat`：
```batch
set SRC_FILE=main.c
set OUT_FILE=hello.exe
set BUILD_TYPE=Release
```

#### 3️⃣ 执行编译

双击 `build.bat` 或在命令行运行：
```cmd
build.bat
```

#### 4️⃣ 运行程序

```cmd
hello.exe
```

输出：
```
Hello, GCC-BAT!
```

✅ 完成！

---

## 实战场景

### 场景 1：编译简单的控制台程序

**目标**: 编译一个简单的计算器程序

**源文件** (calc.c):
```c
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int main() {
    int result = add(10, 20);
    printf("10 + 20 = %d\n", result);
    return 0;
}
```

**配置** (build_config.bat):
```batch
set SRC_FILE=calc.c
set OUT_FILE=calculator.exe
set BUILD_TYPE=Release
```

**运行**:
```cmd
build.bat
calculator.exe
```

输出:
```
10 + 20 = 30
```

---

### 场景 2：调试模式编译

**目标**: 编译代码并用 GDB 调试

**源文件** (debug_test.c):
```c
#include <stdio.h>

int main() {
    int x = 5;
    int y = 10;
    int z = x + y;
    printf("Result: %d\n", z);
    return 0;
}
```

**配置** (build_config.bat):
```batch
set SRC_FILE=debug_test.c
set OUT_FILE=debug_test.exe
set BUILD_TYPE=Debug
```

**编译并调试**:
```cmd
build.bat
gdb debug_test.exe

(gdb) run
Result: 15

(gdb) break main
(gdb) run
(gdb) next
(gdb) print z
$1 = 15
```

---

### 场景 3：多文件编译

**目标**: 编译多个源文件

**文件结构**:
```
utils.c      - 工具函数
math.c       - 数学函数
main.c       - 主程序
```

**utils.c**:
```c
#include <stdio.h>

void print_separator() {
    printf("-----\n");
}
```

**math.c**:
```c
int multiply(int a, int b) {
    return a * b;
}
```

**main.c**:
```c
#include <stdio.h>

void print_separator();
int multiply(int a, int b);

int main() {
    print_separator();
    printf("5 * 6 = %d\n", multiply(5, 6));
    print_separator();
    return 0;
}
```

**配置** (build_config.bat):
```batch
set SRC_FILE=main.c utils.c math.c
set OUT_FILE=multifile.exe
set BUILD_TYPE=Release
```

**编译**:
```cmd
build.bat
multifile.exe
```

输出:
```
-----
5 * 6 = 30
-----
```

---

### 场景 4：优化和压缩

**目标**: 生成体积最小的可执行文件

**配置** (build_config.bat):
```batch
set SRC_FILE=main.c
set OUT_FILE=minimal.exe
set BUILD_TYPE=Release

:: 最小体积优化
set OPT_FLAGS=-Os -march=i586

:: 启用 UPX 压缩
set USE_UPX=1
set "UPX_PATH=C:\tools\upx\upx.exe"
set UPX_FLAGS=--best --lzma
```

**编译并查看文件大小**:
```cmd
build.bat

:: 查看编译日志
type build_log.txt

:: 检查文件大小
dir minimal.exe
```

日志输出示例:
```
[时间] 2026-04-29 10:30:45
模式: Release
编译结果: 成功
文件大小: 524288 字节
[UPX] 压缩后文件大小: 102400 字节
```

---

## 参数速查表

| 参数 | 默认值 | 用途 | 示例 |
|------|--------|------|------|
| `SRC_FILE` | main.c | 源文件 | `main.c` 或 `a.c b.c` |
| `OUT_FILE` | AppRelease.exe | 输出文件 | `myapp.exe` |
| `BUILD_TYPE` | Release | 编译模式 | Release 或 Debug |
| `OPT_FLAGS` | -O3 -march=native | 优化选项 | -O2, -Os 等 |
| `DEBUG_FLAGS` | -O0 -g | 调试选项 | 不建议修改 |
| `PLATFORM_FLAGS` | -mwindows -municode | 平台选项 | -mwindows 等 |
| `SAFE_FLAGS` | -s -fno-ident | 安全选项 | 不建议删除 |
| `LIBS` | -lgdi32 ... | 链接库 | -lpthread, -lws2_32 等 |
| `USE_SINGLE_LINE` | 0 | 单行编译 | 0=禁用, 1=启用 |
| `USE_UPX` | 0 | UPX 压缩 | 0=禁用, 1=启用 |

---

## 高级技巧

### 技巧 1：预设优化方案

创建多个配置文件，快速切换：

**build_release_fast.bat** (速度优先):
```batch
set OPT_FLAGS=-O3 -march=native -flto -fomit-frame-pointer
set BUILD_TYPE=Release
call build.bat
```

**build_release_small.bat** (体积优先):
```batch
set OPT_FLAGS=-Os -march=i586
set BUILD_TYPE=Release
set USE_UPX=1
call build.bat
```

**build_debug.bat** (调试):
```batch
set BUILD_TYPE=Debug
call build.bat
```

### 技巧 2：批量编译

**compile_all.bat**:
```batch
@echo off
echo 编译所有程序...

echo [1/3] 编译 app1...
set SRC_FILE=app1.c
set OUT_FILE=app1.exe
call build.bat

echo [2/3] 编译 app2...
set SRC_FILE=app2.c
set OUT_FILE=app2.exe
call build.bat

echo [3/3] 编译 app3...
set SRC_FILE=app3.c
set OUT_FILE=app3.exe
call build.bat

echo 全部编译完成!
```

### 技巧 3：条件编译

在 build.bat 中添加：
```batch
if "%1"=="debug" (
    set BUILD_TYPE=Debug
)
if "%1"=="release" (
    set BUILD_TYPE=Release
)
if "%1"=="small" (
    set OPT_FLAGS=-Os
)
```

然后使用：
```cmd
build.bat debug
build.bat release
build.bat small
```

### 技巧 4：自动版本管理

在 build.bat 中添加：
```batch
set VERSION=1.0.0
echo #define BUILD_VERSION "1.0.0" > version.h
echo #define BUILD_TIME "%date% %time%" >> version.h

gcc %SRC_FILE% -o %OUT_FILE% %COMPILE_FLAGS%
```

在 main.c 中使用：
```c
#include "version.h"
printf("Version: %s\n", BUILD_VERSION);
```

### 技巧 5：编译后自动运行

在 build.bat 末尾添加：
```batch
if "%RESULT%"=="0" (
    echo 编译成功，启动程序...
    %OUT_FILE%
)
```

---

## 工作流示例

### 开发阶段

```cmd
:: 第 1 步：Debug 编译
build.bat
debug_test.exe

:: 第 2 步：调试
gdb debug_test.exe

:: 第 3 步：修改代码（用编辑器）
:: 编辑 main.c

:: 第 4 步：重新编译
build.bat

:: 重复第 2-4 步直到满意
```

### 发布阶段

```cmd
:: 第 1 步：切换到 Release 模式
:: 编辑 build_config.bat，将 BUILD_TYPE 改为 Release

:: 第 2 步：最后一次测试编译
build.bat

:: 第 3 步：启用优化和压缩
:: set OPT_FLAGS=-O3 -march=native -flto
:: set USE_UPX=1

:: 第 4 步：最终编译
build.bat

:: 第 5 步：检查日志
type build_log.txt

:: 第 6 步：发布
:: 上传 AppRelease.exe
```

---

## 常见命令

### 查看编译历史

```cmd
type build_log.txt
```

### 清空日志

```cmd
del build_log.txt
```

### 清理编译输出

```cmd
del *.exe *.o
```

### 比较文件大小

```cmd
dir *.exe
```

### 查看程序依赖库

```cmd
objdump -p app.exe | findstr "DLL"
```

### 对比两次编译

```cmd
:: 编译 v1
set OUT_FILE=app_v1.exe
build.bat

:: 修改代码...

:: 编译 v2
set OUT_FILE=app_v2.exe
build.bat

:: 比较
fc app_v1.exe app_v2.exe
```

---

## 故障快速排查

| 问题 | 检查 | 解决 |
|------|------|------|
| "gcc: command not found" | GCC 是否安装 | 安装 MinGW |
| 编译失败 | 查看日志 build_log.txt | 查看 [TROUBLESHOOTING.md](TROUBLESHOOTING.md) |
| 无输出 | 是否使用 -mwindows | 移除该选项 |
| 文件很大 | 是否进行优化 | 使用 -Os 或 UPX |
| 程序崩溃 | 是否缺少库 | 检查 LIBS 配置 |

---

## 下一步

- 📖 查看 [完整文档](DOCUMENTATION.md) 了解深层原理
- 🔧 查看 [参数参考](API_REFERENCE.md) 了解所有选项
- 🐛 查看 [故障排除](TROUBLESHOOTING.md) 解决问题

---

**快速入门版本**: 1.0  
**最后更新**: 2026-04-29
