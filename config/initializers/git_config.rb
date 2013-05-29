# Not the best way to do this
# But it's one way

require 'fileutils'

FileUtils.cd "#{Rails.root}/.." do
  File.open('.git/hooks/pre-commit', 'w') do |f|
    f.write <<-eos.strip_heredoc
      #!/bin/sh
      . Idearator/script/pre-commit-checks.sh
    eos
  end
  FileUtils.chmod(0755, '.git/hooks/pre-commit')

  system('git config core.fileMode false')
  system('git config core.eol lf')
  system('git config core.autocrlf input')
  system('git config core.whitespace "space-before-tab,tab-in-indent,trailing-space,tabwidth=2"')
end

