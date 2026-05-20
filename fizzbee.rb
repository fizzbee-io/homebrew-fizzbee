class Fizzbee < Formula
  desc "A formal specification language and model checker to specify distributed systems."
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.5.0"

  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.5.0/fizzbee-v0.5.0-macos_arm.tar.gz"
    sha256 "d8e87a772bbaec0ef7dc3b9f2063de270bfb56b812b93a24a748dafc0efa3ce4"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.5.0/fizzbee-v0.5.0-macos_x86.tar.gz"
    sha256 "2422d1c6bcf41f7c12385ce9480ac382d869b33d92e1ff0279005fadda2c3f16"
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
