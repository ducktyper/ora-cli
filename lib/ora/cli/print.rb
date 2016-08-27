module Ora::Cli
  class Print
    def initialize(silent = false)
      @silent = silent
    end

    def inline text
      print text unless @silent
      text
    end

    def plain text
      puts text unless @silent
      text
    end

    def green text
      puts "\e[32m#{text}\e[0m" unless @silent
      text
    end

    def red text
      puts "\e[31m#{text}\e[0m" unless @silent
      text
    end
  end
end
