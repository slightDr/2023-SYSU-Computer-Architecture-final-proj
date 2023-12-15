# 复现方法

## 1. 安装依赖

使用下面的命令一键安装所有依赖：
```bash
sudo apt install build-essential git m4 scons zlib1g zlib1g-dev \
    libprotobuf-dev protobuf-compiler libprotoc-dev libgoogle-perftools-dev \
    python3-dev python-is-python3 libboost-all-dev pkg-config
```

## 2. 安装 LLVM 和 Clang
```bash
sudo apt install llvm
sudo apt install clang
```

## 3. 下载并编译 gem5-SALAM
```
git clone https://github.com/slightDr/2023-SYSU-Computer-Architecture-final-proj
```
**进入文件夹2023-SYSU-Computer-Architecture-final-proj**进行编译，其中 `nproc` 的值为**电脑的核数+1**，比如我的是双核虚拟机则用 `-j3`。所需时间视核数的不同而变化，我的双核虚拟机需要编译半个小时以上。
```
scons build/ARM/gem5.opt -j<nproc>
```

## 4. 使用 gem5-SALAM
为了使用系统验证基准测试，需要安装 $ARM\space GCC$ 交叉编译器。如果在设置依赖项时尚未安装它，可以通过运行以下命令在 $Ubuntu$ 上进行安装：

```shell
sudo apt-get install gcc-multilib gcc-arm-none-eabi
```

`systemValidation.sh` 需要设置一个名为 `M5_PATH` 的环境变量。你应该将其指向你的 `2023-SYSU-Computer-Architecture-final-proj` 路径，如下所示。

```bash
export M5_PATH=/path/to/2023-SYSU-Computer-Architecture-final-proj
```

切换到想要运行的基准测试软件目录下，并编译（`[benchmark]` 是测试软件的名字，选项有 `bfs`/`fft`/`gemm`等，具体可以进入文件夹查看。后续也是如此）

```bash
cd $M5_PATH/benchmarks/sys_validation/<benchmark>
make
```

最后回到 `M5_PATH` 路径下即文件夹2023-SYSU-Computer-Architecture-final-proj的第一级，运行以下指令即可模拟该基准程序：

```bash
cd $M5_PATH
./systemValidation.sh -b <benchmark>
```

基准测试程序的运行结果，包括动态、静态能量等具体参数。
