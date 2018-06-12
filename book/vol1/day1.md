# Day 1 - Cargo and crates.io

受到 Ollie Charles 和他的 [24 days of Hackage](https://ocharles.org.uk/blog/pages/2013-12-01-24-days-of-hackage.html) 系列文章的启发, 我尝试用一系列文章来介绍Rust语言的一些特性、有用的库，以及一些超酷的项目。同时这也是我学习Rust的一个过程，我超级喜爱Rust这么语言的！
如果你在阅读过程当中，觉得哪里有错误，或者你有哪些感兴趣的库想告诉我，欢迎大家在评论里相互交流！

那么，让我们开始吧！ 就像 Ollie 写的有关 Haskell 的系列文章中 [introduced Cabal](https://ocharles.org.uk/blog/posts/2012-12-01-24-days-of-hackage.html) 一样，第一篇文章通常以包管理工具开始。如果你熟悉Python, Ruby或者是Node， 那么你一定对包管理工具十分熟悉，但是如果你是C++ 程序员，那么由于C++没有内建的包管理工具，所以Rust对他们而言，包管理工具也是吸引他们的一个特性。

Cargo
-----

**Cargo**  是Rust的包管理工具。你可以通过 `rustup.sh` 这个脚本连同编译器一起安装。
Cargo 能够编译你的代码并管理代码的依赖，同时它也能够帮助程序员生成基础的项目结构，你只需要这么做：

```sh
$ cargo new myproject --bin # 或者 --lib, 如果你想创建一个库
```

Cargo 将会在一个名叫`Cargo.toml`的文件中生成一些初始配置（有的时候这个文件也被称为*manifest*文件），在这个文件中，你可以添加一些项目的元信息，包括姓名，版本等等。
在这个文件中，也可以用于描述本项目的依赖信息，你可以查看这个示例的配置文件获取更多信息：[Cargo.toml](https://github.com/zsiciarz/euler.rs/blob/7e7f93c395a8eb010221015fa3585d8c70663cd7/Cargo.toml) ,这个文件来自我的一个Demo项目:

```ini
[package]

name = "euler"
version = "0.0.1"
authors = ["Zbigniew Siciarz <zbigniew@siciarz.net>"]

[dependencies]
getopts = "~0.2.14"
num = "~0.1.36"
permutohedron = "~0.2.2"
primal = "~0.2.3"
```

Cargo 同时也能够运行一个测试套件，生成文档，或者上传你的crate到仓库中，但是这些主题我们留到后面再说。

Crates 和依赖
-----------------------

你可能不知道，Rust把它的编译单元（可以是一个库或者是一个可执行文件）称为 **crate** 。
你的Rust程序往往会编译成一个crate，但是它同时可以使用别的crate作为它的依赖。你可以通过查阅官方文档来
[Rust Guide on crates](http://doc.rust-lang.org/guide.html#crates-and-modules) 获取更多有关crate和模块的相关信息。

通过执行 `cargo build` 来编译你的 crate ，编译之后的二级制文件将会放到 `target/` 目录下，对于可执行文件而言有一个很便捷的执行程序的方式 —— `cargo run` ，这个命令将会帮你编译代码并运行可执行文件。

你可能已经注意到了在前文提到的menifest文件中的 `[dependencies]` 字段。
你也可能已经猜到了——这个文件就是用来指定你需要用到的外部库的信息。但是只有 `Cargo.toml` 还是不够的 —— 它仅仅就是告诉 Cargo 把这些 crate 同你的项目代码链接起来。 为了能够使用它们开放的 API，你还需要在你的项目根目录下（通常是`main.rs` 或者是 `lib.rs` ）中声明 `extern crate` 来引入相关 API 模块。这样编译器才能够引用到这些 API 函数。

例如：

```rust
// main.rs
extern crate num;

fn main () {
    // ... use stuff from num library
}
```

**注意**: 目前 Cargo 还仅仅支持包含源代码的 crate, 它将会把所有的 crate 的源代码都下载到你目前项目中，然后编译并链接成为你项目 crate 的一部分。

这也是我个人为什么这么喜欢 Cargo 的原因之一，因为它把编译一个库和一个二进制处理得非常简单，以至于在 minifest 配置文件中仅仅需要两个字段。例如这个项目中 [rust-cpuid](https://github.com/zsiciarz/rust-cpuid) 所展示的:

```ini
[lib]
name = "cpuid"

[[bin]]
name = "cpuid"
```

然后我只需要将 `extern crate cpuid` 放到 `main.rs` 文件中（这是可执行的 crate 的根目录），然后 Cargo 会帮你一起编译链接这个库。

**更新**: 在 [Steve Klabnik](http://www.reddit.com/r/rust/comments/2nybtm/24_days_of_rust_cargo_and_cratesio/cmip7xw) 提及的, 这两小节其实是多余的，因为这些都是默认的。如果你有包括 `lib.rs` 和 `main.rs` 在源代码文件路径下，Cargo 将会同时编译库和可执行文件。

crates.io
---------

[crates.io](https://crates.io/) 是 Cargo 的中心包存储仓库（就像 Python 的 PyPI 一样）。
Cargo 从这里拉取依赖代码，虽然你也可以通过 Git 或者是本地文件系统得到代码，但是一旦你想要编译一个超酷的库，并希望把它分享给世界各地，crates.io 绝对是不错的选择。
你可能需要一个账户来上传你的代码（目前你只可以通过 Github 账户进行登录，但我相信不久之后这个限制将会改进）。发布包的相关命令是 `cargo publish`，在官方文档 [section on publishing crates](http://doc.crates.io/crates-io.html#publishing-crates) 中有做说明。
一旦你完成了这个工作，恭喜你，你已经是 Rust 生态的一名优秀的贡献者啦！
