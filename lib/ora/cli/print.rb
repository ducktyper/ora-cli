module Ora::Cli
  class Print
    def initialize(silent = false)
      @silent = silent
    end
    def puts_plain text
      puts text unless @silent
    end
    def print_plain text
      print text unless @silent
    end

    def puts_green text
      puts "\e[32m#{text}\e[0m" unless @silent
    end
    def print_green text
      print "\e[32m#{text}\e[0m" unless @silent
    end

    def puts_red text
      puts "\e[31m#{text}\e[0m" unless @silent
    end
    def print_red text
      print "\e[31m#{text}\e[0m" unless @silent
    end
  end
end
