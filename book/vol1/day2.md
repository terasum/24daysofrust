# Day 2 - primal

> Relevancy: 1.9 stable

当我开始学习一门新的编程语言时，我喜欢在 [Project Euler](https://projecteuler.net/) 上通过解决一些问题的方式来巩固学习。
这些是非常面向数学的问题，和通常我们编程的目标有些差别，但是这仅仅只是开始，我就是为了在解决他们的过程当中寻找一些乐趣！（而且在解决他们的过程当中，寻找一个更快更便捷的方法，那就更有意思了！）

在很多 Project Euler 的问题当中，都涉及到了素数的处理。
包括寻找第 `n` 个素数，高效的质因数分解，以及判断一个数是否是素数。
当然你可以自己写一些算法来解决这些问题，这也是一种有效的自学方式，但是我比较懒，通常都会找一些已经完成的解法，例如[Huon Wilson](http://huonw.github.io/) 的库[primal](https://github.com/huonw/primal) ，然后再在其基础上进行转译代码。
所以其实这就是我最早使用的一个Rust的外部库，远比 crates.io 要早（当时这个库被叫做 `slow_primes` ）。

那么让我们看看这里面都有什么吧。

素数筛
-----------

第一件我们要完成的任务是创建一个 **素数筛** (参阅 [Wikipedia on Sieve of Eratosthenes](http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes) 以获取详细算法说明)
这里有一个非常机智的方法来获取素数计算范围 (参阅 [estimate_nth_prime](http://huonw.github.io/primal/primal/fn.estimate_nth_prime.html)), 但是我现在想先通过硬编码的形式将其设置为 10000。

让我们试试检查一下一个数是否是素数吧！

[include:1-4](../../vol1/src/bin/day2.rs)

[include:11-16](../../vol1/src/bin/day2.rs)

如何去得到第1000个素数呢？

[include:18-22](../../vol1/src/bin/day2.rs)

其中的 `primes_from()` 方法会返回一个通过素数筛 (2, 3, 5, 7) 得到的素数的迭代器。Rust中的迭代器有很多很实用的方法，比如 `nth()` 会迭代`n`次，返回第 `n` 个元素 （如果以及超过了迭代器的返回，将会返回 `None` ）。 当然我们的迭代都是从 0 开始的， 所以我们需要传入 999 以取得第1000个素数。

质因数分解
-------------

质因数分解就是将一个数分解为多个素数相乘的形式。
例如： `2610 = 2 * 3 * 3 * 5 * 29`. 这里我们可以通过 `primal` API 以取得结果:

[include:23-23](../../vol1/src/bin/day2.rs)



当我们运行这段代码，可以得到:

```sh
$ cargo run
Ok([(2, 1), (3, 2), (5, 1), (29, 1)])
```

这是啥？让我们看看函数 `factor`的返回类型：

```rust
type Factors = Vec<(usize, usize)>;
fn factor(&self, n: usize) -> Result<Factors, (usize, Factors)>
```

看上去好像有点复杂，但是请记住这个
[Result](http://doc.rust-lang.org/std/result/enum.Result.html) 类型。 变量 `Ok` 包括了一组数值对,每一对都包括了一个素数因子（系数）以及其x的指数(想象一下 `y = x^2 + 2x + 1`, x 的指数就是这里的平方和 x 一次)。
为了避免错误，我们将会得到一对值 (系数，指数)。

我们可以通过质因数来寻找所有被除数的数量（包括合数）,这在数论中非常重要（虽然原因已经超出了这篇文章涉及到的范围）。

让我们看看下面的这个函数:

[include:5-9](../../vol1/src/bin/day2.rs)

这里的技巧是把所有的质因数相乘，这样我们就能够得到一个数的因数个数了。这个技巧在这篇文章中有作介绍: [explanation at Maths Challenge](http://mathschallenge.net/library/number/number_of_divisors)。

所以我当我们计算 2610 的结果的时候，我们可以得到 `Some(24)` 作为我们的结果。

[include:24-24](../../vol1/src/bin/day2.rs)

扩展阅读
---------------

 * [Divisor function](http://en.wikipedia.org/wiki/Divisor_function)
 * [Miller-Rabin primality test](http://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test)
 * [GMP algorithms page](https://gmplib.org/manual/Algorithms.html#Algorithms)
 * [consecutive prime sum](https://projecteuler.net/problem=50) - an interesting Project Euler problem
