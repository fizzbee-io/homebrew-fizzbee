class Fizzbee < Formula
  desc "A formal specification language and model checker to specify distributed systems."
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.3.0"

  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.3.0/fizzbee-v0.3.0-macos_arm.tar.gz"
    sha256 "5c683c033d5cc141a75d2d07c480b2ae3493d1ec9eced9f7807cf0830650025d"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.3.0/fizzbee-v0.3.0-macos_x86.tar.gz"
    sha256 "f767ac3235a8d291787affb52d8a54dfe9ed0d66d6293fdb0313dbba0d7d82c7"
  end

  def install
    # Install all files to libexec
    libexec.install "fizzbee"
    libexec.install "parser"
    libexec.install "fizz.env"
    libexec.install "fizz"
    libexec.install "mbt_gen.zip"

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
