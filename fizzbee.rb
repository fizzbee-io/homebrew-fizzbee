class Fizzbee < Formula
  desc "A formal specification language and model checker to specify distributed systems."
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.3.1"

  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.3.1/fizzbee-v0.3.1-macos_arm.tar.gz"
    sha256 "f73668a13e87d76c613a2826333b000add9fd1e3f1e89815fbe33032ab65b341"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.3.1/fizzbee-v0.3.1-macos_x86.tar.gz"
    sha256 "cb44fa54d89123f9f1deaa0789ffd53ee5ab9ec561c0490469499b28f5c8c403"
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
