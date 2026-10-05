class Fizzbee < Formula
  desc "A formal specification language and model checker to specify distributed systems."
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.5.4"

  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.5.4/fizzbee-v0.5.4-macos_arm.tar.gz"
    sha256 "2091d0a1bf5acc41015f8644cbaf5ec853ed0c88283a7f94d615135a6c8a441c"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.5.4/fizzbee-v0.5.4-macos_x86.tar.gz"
    sha256 "e9133999d2e647dc54ae6cc7160ce11c21581bf859b559aaa6d3409f3fd59fe3"
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
