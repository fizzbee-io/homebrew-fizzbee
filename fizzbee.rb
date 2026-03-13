class Fizzbee < Formula
  desc "A formal specification language and model checker to specify distributed systems."
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.4.0"

  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.4.0/fizzbee-v0.4.0-macos_arm.tar.gz"
    sha256 "73bb1711b5daad43a1b5c61e097f23a4c5f83f3a58d466234c2cc44b7135eaac"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.4.0/fizzbee-v0.4.0-macos_x86.tar.gz"
    sha256 "bf7592f608360605e10e902275c3780a34df81606395ec501891c66b0ccd26a5"
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

  def caveats
    <<~EOS
      To install Claude Code skills for FizzBee:
        fizz install-skills
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
