# 🔧 故障排除指南

## 编译错误

### 错误 1: "gcc: command not found"

**症状**: 运行 build.bat 后立即显示错误

```
'gcc' is not recognized as an internal or external command
```

**原因**: GCC 未正确安装或未添加到系统 PATH

**解决方案**:

1. **验证 GCC 安装**
   ```cmd
   gcc --version
   ```
   - 如果显示版本信息，说明已安装
   - 如果出现"命令不找到"，需要安装 MinGW

2. **安装 MinGW**
   - 访问 https://www.mingw-w64.org/
   - 下载 MinGW-w64 installer
   - 安装到如 `C:\mingw64`

3. **配置 PATH**
   - 打开"系统环境变量"
   - 找到 PATH 环境变量，点击编辑
   - 添加 MinGW 的 bin 目录（如 `C:\mingw64\bin`）
   - 重启命令行

4. **验证**
   ```cmd
   gcc --version
   ```

---

### 错误 2: "No such file or directory"

**症状**: 
```
gcc: error: main.c: No such file or directory
```

**原因**: 源文件路径错误或文件不存在

**解决方案**:

1. **检查文件是否存在**
   ```cmd
   dir main.c
   ```

2. **检查文件位置**
   - 确保源文件与 build.bat 在同一目录
   - 或使用完整路径: `set SRC_FILE=C:\path\to\main.c`

3. **检查路径中是否有空格**
   - 如果路径含空格，需要加引号:
   ```batch
   set SRC_FILE="my source.c"
   ```

4. **检查文件名大小写**
   - 某些系统区分大小写
   - 确保 build_config.bat 中的文件名与实际文件名匹配

---

### 错误 3: "undefined reference to"

**症状**:
```
undefined reference to `printf'
```

**原因**: 缺少所需的库链接

**解决方案**:

1. **识别缺少的库**
   - 错误信息通常会指示需要的函数
   - 根据函数查找对应的库

2. **常见库映射**
   
   | 函数 | 库 |
   |------|-----|
   | printf, sprintf | 标准 C 库（默认链接） |
   | socket, connect | -lws2_32 (Winsock) |
   | CreateWindow | -luser32 (User32) |
   | DrawText | -lgdi32 (GDI32) |
   | GetOpenFileName | -lcomdlg32 |
   | InterpolateColors | -lmsimg32 |

3. **添加库到 build_config.bat**
   ```batch
   set LIBS=%LIBS% -lws2_32
   ```

4. **验证库是否存在**
   ```cmd
   gcc -l ws2_32
   ```

---

### 错误 4: "multiple definitions of"

**症状**:
```
multiple definitions of `main'
```

**原因**: 在 SRC_FILE 中指定了多个包含 main() 函数的文件

**解决方案**:

1. **检查 SRC_FILE**
   ```batch
   set SRC_FILE=main.c util.c
   ```
   - 只有一个文件应该定义 main()

2. **解决方案**: 分离编译
   ```batch
   :: util.c 不需要 main()，只编译为目标文件
   gcc -c util.c -o util.o
   
   :: 然后编译 main.c 并链接
   gcc main.c util.o -o app.exe
   ```

---

### 错误 5: "relocation R_X86_64_32"

**症状**:
```
relocation R_X86_64_32 against `symbol' can not be used when making a shared object
```

**原因**: 编译 64 位代码时使用了不兼容的选项

**解决方案**:

1. **添加 -fPIC 选项**
   ```batch
   set OPT_FLAGS=-O3 -march=native -fPIC
   ```

2. **或使用 32 位编译**
   ```batch
   set PLATFORM_FLAGS=-m32
   ```

---

## 运行时错误

### 错误 6: "应用程序无法启动：DLL 未找到"

**症状**: 生成的 .exe 无法运行

```
应用程序无法启动，因为找不到 libgcc_s_sjlj-1.dll
```

**原因**: MinGW 运行时库缺失

**解决方案**:

1. **查看依赖库**
   ```cmd
   objdump -p app.exe | findstr "DLL"
   ```

2. **动态链接库位置**
   - 将 MinGW bin 目录中的 DLL 复制到 app.exe 目录
   - 或添加 MinGW bin 目录到 PATH

3. **静态链接**
   ```batch
   set LIBS=%LIBS% -static-libgcc -static-libstdc++
   ```

---

### 错误 7: 程序立即退出或无输出

**症状**: .exe 运行后闪退或没有任何输出

**原因**: 
- GUI 模式（-mwindows）但没有 GUI 代码
- 程序有错误但没有错误处理

**解决方案**:

1. **移除 -mwindows**
   ```batch
   set PLATFORM_FLAGS=
   ```

2. **切换到 Debug 模式调试**
   ```batch
   set BUILD_TYPE=Debug
   set OUT_FILE=app_debug.exe
   ```

3. **使用 GDB 调试**
   ```cmd
   gdb app_debug.exe
   run
   ```

---

### 错误 8: 性能低下

**症状**: 编译后的程序运行缓慢

**解决方案**:

1. **增加优化选项**
   ```batch
   set OPT_FLAGS=-O3 -march=native -flto -fomit-frame-pointer -funroll-loops
   ```

2. **检查调试符号**
   ```batch
   set SAFE_FLAGS=-s -fno-ident
   ```

3. **启用 LTO (链接时优化)**
   ```batch
   set OPT_FLAGS=-O3 -flto
   ```

---

## 配置问题

### 问题 1: 日志文件显示乱码

**症状**: build_log.txt 在记事本中显示乱码

**原因**: 这是 UTF-16 LE 编码（正常现象）

**解决方案**:

1. **使用记事本打开** (推荐)
   - Windows 记事本会自动识别 BOM 并正确显示
   
2. **其他编辑器设置**
   - VSCode: 右下角选择 "UTF-16 LE"
   - Notepad++: 编码 → 转为 UTF-16 LE

3. **这是设计功能**
   - UTF-16 LE BOM 触发记事本的"日志模式"
   - 日志会自动滚动到最后
   - 完全正常，不是错误

---

### 问题 2: 编译参数没有生效

**症状**: 修改了参数但编译结果不变

**原因**: 
- 单行模式启用了 (USE_SINGLE_LINE=1)
- 命令行参数覆盖了配置文件

**解决方案**:

1. **关闭单行模式**
   ```batch
   set USE_SINGLE_LINE=0
   ```

2. **检查是否有参数被注释**
   ```batch
   :: set OPT_FLAGS=-O3  (这一行被注释了)
   ```

3. **确保保存了文件**
   - 修改 build_config.bat 后一定要保存

---

### 问题 3: UPX 压缩失败

**症状**: 
```
UPX: error: ...
```

**原因**:
- UPX 未安装
- UPX_PATH 路径错误
- 某些类型的可执行文件不支持 UPX 压缩

**解决方案**:

1. **验证 UPX 安装**
   ```cmd
   D:\Program\upx\upx.exe --version
   ```

2. **更新 UPX_PATH**
   - 检查实际的 UPX 路径
   ```batch
   set "UPX_PATH=C:\tools\upx\upx.exe"
   ```

3. **禁用 UPX**
   ```batch
   set USE_UPX=0
   ```

4. **修改 UPX 参数**
   ```batch
   set UPX_FLAGS=--best
   ```

---

### 问题 4: 输出文件被锁定

**症状**:
```
permission denied: 'app.exe'
```

**原因**: 输出文件正在被使用

**解决方案**:

1. **关闭使用该文件的程序**
   - 确保 .exe 没有在运行
   - 某些工具可能持有文件句柄

2. **使用不同的输出名**
   ```batch
   set OUT_FILE=app_new.exe
   ```

3. **查看谁在使用文件**
   ```cmd
   tasklist | findstr app.exe
   ```

4. **强制关闭**
   ```cmd
   taskkill /F /IM app.exe
   ```

---

## 调试技巧

### 技巧 1: 详细编译信息

**需求**: 查看完整编译命令和过程

**方法**:

1. **在 build.bat 中移除重定向**
   ```batch
   :: 原来：
   gcc %SRC_FILE% -o %OUT_FILE% %COMPILE_FLAGS%
   
   :: 改为（显示所有输出）：
   gcc -v %SRC_FILE% -o %OUT_FILE% %COMPILE_FLAGS%
   ```

2. **输出编译命令**
   ```batch
   echo 完整编译命令:
   echo gcc %SRC_FILE% -o %OUT_FILE% %COMPILE_FLAGS%
   ```

### 技巧 2: 只编译不链接

**需求**: 检查语法错误，不生成可执行文件

**方法**:

```batch
:: 仅编译，生成目标文件 (.o)
gcc -c %SRC_FILE% -o %OUT_FILE%.o %COMPILE_FLAGS%
```

### 技巧 3: 生成汇编代码

**需求**: 查看生成的汇编代码

**方法**:

```batch
gcc -S %SRC_FILE% -o output.s %COMPILE_FLAGS%
```

### 技巧 4: 预处理输出

**需求**: 查看预处理后的代码（宏展开等）

**方法**:

```batch
gcc -E %SRC_FILE% > preprocessed.c
```

### 技巧 5: 链接检查

**需求**: 检查符号和依赖关系

**方法**:

```batch
nm app.exe
```

---

## 诊断清单

遇到问题时的检查清单：

- [ ] GCC 已安装: `gcc --version`
- [ ] PATH 已配置: `gcc --version` 返回版本
- [ ] 源文件存在: `dir %SRC_FILE%`
- [ ] 配置文件语法正确（无拼写错误）
- [ ] 输出文件路径有效（无非法字符）
- [ ] 所有库都正确添加到 LIBS
- [ ] 没有文件被其他程序占用
- [ ] build_config.bat 已保存
- [ ] 没有启用单行模式（除非故意）
- [ ] 日志文件可读（查看 build_log.txt）

---

## 获取帮助

如果上述方案都不能解决问题：

1. **查看完整日志**
   - 打开 build_log.txt 查看详细错误信息
   
2. **尝试最小化例子**
   - 创建最简单的 C 程序测试
   ```c
   #include <stdio.h>
   int main() {
       printf("Hello\n");
       return 0;
   }
   ```

3. **逐步简化配置**
   - 关闭所有可选功能（UPX、优化等）
   - 使用最基础的编译命令

4. **查看相关文档**
   - [完整文档](DOCUMENTATION.md)
   - [快速入门](QUICK_START.md)
   - [参数参考](API_REFERENCE.md)

---

**最后更新**: 2026-04-29  
**故障排除版本**: 1.0
