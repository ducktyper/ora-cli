module Bash
  def bash(from: nil, silent: false)
    yield.split("\n").map(&:strip).reject(&:empty?).each do |command|
      move = "cd #{from} && " if from
      out  = " &> /dev/null"  if silent
      `#{move}#{command}#{out}`
    end
  end
end
