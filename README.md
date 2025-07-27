# homebrew-fizzbee

A Homebrew formula for [FizzBee](https://github.com/fizzbee-io/fizzbee).

FizzBee is a formal specification language designed to specify and verify distributed systems. It helps identify bugs and edge cases in concurrent and distributed algorithms.

For more information, visit the [official FizzBee repository](https://github.com/fizzbee-io/fizzbee).

## Installation

```bash
brew tap flaneur2020/fizzbee
brew install fizzbee
```

## Usage

After installation, you can use the `fizz` command. Here's a simple FizzBee program (`hello.fizz`):

```fizz
action Init:
  a = 0
  b = 0

action Add:
  oneof:
    a = (a + 1) % 3
    b = (b + 1) % 3
```

Run it with:

```bash
fizz hello.fizz
```
