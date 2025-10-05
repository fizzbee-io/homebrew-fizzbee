class Fizzbee < Formula
  desc "A formal specification language and model checker to specify distributed systems."
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.2.1"

  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.1.2/fizzbee-v0.1.2-macos_arm.tar.gz"
    sha256 "804a64e36b01502ffcebf63b3a9ac21aadb79f56421c7429b723b28925f09d20"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.1.2/fizzbee-v0.1.2-macos_x86.tar.gz"
    sha256 "08a409e1ce3df641da022d9f29d3430bb2ddfdda06ae59a527dcce4f76ce6a2e"
  end

  def install
    # Install all files to libexec
    libexec.install "fizzbee"
    libexec.install "parser"
    libexec.install "fizz.env"
    libexec.install "fizz"

    # Create wrapper script that sets correct environment variables
    (bin/"fizz").write <<~EOS
      #!/bin/bash
      export PARSER_BIN="#{libexec}/parser/parser_bin"
      export FIZZBEE_BIN="#{libexec}/fizzbee"
      exec "#{libexec}/fizz" "$@"
    EOS
  end

  test do
    # Test basic execution with a simple FizzBee program
    (testpath/"hello.fizz").write <<~EOS
    action Init:
      a = 0
      b = 0

    action Add:
      oneof:
        a = (a + 1) % 3
        b = (b + 1) % 3
    EOS

    # Test that the interpreter can parse and potentially execute a basic program
    system "#{bin}/fizz", "hello.fizz"
  end
end
