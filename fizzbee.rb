class Fizzbee < Formula
  desc "FizzBee programming language interpreter"
  homepage "https://github.com/fizzbee-io/fizzbee"  # 替换为你的实际仓库
  url "https://github.com/fizzbee-io/fizzbee/releases/download/v0.1.2/fizzbee-v0.1.2-macos_arm.tar.gz"  # 替换为实际下载链接
  sha256 "fbc2846e494f23bab6cb89ca89067a86551852a0c3cc2a796b51c11b1ed6614a2"  # 需要计算实际的SHA256
  version "0.1.2"

  depends_on "python@3.12"

  def install
    bin.install "fizzbee"
    
    libexec.install "parser"
    
    libexec.install "fizz.env"
    
    (bin/"fizzbee").write <<~EOS
      #!/bin/bash
      export SCRIPT_DIR="#{libexec}"
      source "#{libexec}/fizz.env"
      exec "#{libexec}/fizzbee" "$@"
    EOS
    
    rm "#{bin}/fizzbee"
    mv "#{libexec}/fizzbee", "#{bin}/fizzbee-bin"
    
    (bin/"fizzbee").write <<~EOS
      #!/bin/bash
      export SCRIPT_DIR="#{libexec}"
      source "#{libexec}/fizz.env"
      exec "#{bin}/fizzbee-bin" "$@"
    EOS
  end

  test do
    system "#{bin}/fizz", "--help"
  end
end
