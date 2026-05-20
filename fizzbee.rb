class Fizzbee < Formula
  desc "A formal specification language and model checker to specify distributed systems."
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.5.1"

  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.5.1/fizzbee-v0.5.1-macos_arm.tar.gz"
    sha256 "1b246470618d0398bb61fabb2a84c6aa0448a0e880faf7ad74e50e3fe1a268ee"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.5.1/fizzbee-v0.5.1-macos_x86.tar.gz"
    sha256 "2118bab66295aa93a852599958b26907f2182959820528382a289c06137ca219"
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
