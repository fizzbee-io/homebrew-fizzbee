class Fizzbee < Formula
  desc "FizzBee programming language interpreter"
  homepage "https://github.com/fizzbee-io/fizzbee"
  version "0.1.2"
  
  if Hardware::CPU.arm?
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.1.2/fizzbee-v0.1.2-macos_arm.tar.gz"
    sha256 "fbc2846e494f23bab6cb89ca89067a86551852a0c3cc2a796b51c11b1ed6614a2"
  else
    url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.1.2/fizzbee-v0.1.2-macos_x86.tar.gz"
    sha256 "REPLACE_WITH_ACTUAL_X86_SHA256"
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
    system "#{bin}/fizz", "--help"
  end
end
