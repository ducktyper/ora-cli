module Ora::Cli
  module Print
    def puts_green text
      puts "\e[32m#{text}\e[0m"
    end
    def puts_red text
      puts "\e[31m#{text}\e[0m"
    end
  end
end
