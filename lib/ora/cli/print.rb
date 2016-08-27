module Ora::Cli
  class Print
    def initialize(silent = false)
      @silent = silent
    end

    def inline text
      print text unless @silent
    end

    def plain text
      puts text unless @silent
    end

    def green text
      puts "\e[32m#{text}\e[0m" unless @silent
    end

    def red text
      puts "\e[31m#{text}\e[0m" unless @silent
    end
  end
end
