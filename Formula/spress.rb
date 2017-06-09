require File.expand_path("../../Abstract/abstract-php-phar", __FILE__)

class Spress < AbstractPhpPhar
  desc "The static site generator in PHP"
  homepage "http://spress.yosymfony.com"
  url "https://github.com/spress/Spress/releases/download/v2.2.0/spress.phar"
  sha256 "06d77d17e97737ded9d0fc0ea3d2d3a93c4a7075879618dba5d0dfcaf1742049"
  version "2.2.0"

  depends_on PharRequirement

  test do
    system "#{bin}/spress", "--version"
  end

  # The default behavior is to create a shell script that invokes the phar file.
  # Other tools, at least Ansible, expect the composer executable to be a PHP
  # script, so override this method. See
  # https://github.com/Homebrew/homebrew-php/issues/3590
  def phar_wrapper
    <<-EOS.undent
      #!/usr/bin/env php
      <?php
      array_shift($argv);
      $arg_string = implode(' ', array_map('escapeshellarg', $argv));
      $arg_string .= preg_match('/--(no-)?ansi/', $arg_string) ? '' : ' --ansi';
      passthru("/usr/bin/env php -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/#{@real_phar_file} $arg_string", $return_var);
      exit($return_var);
    EOS
  end
end
