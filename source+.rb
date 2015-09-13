#
# Author: Ch0c0late
# Date: Aug. 25 2015
#
# source+.rb
#

$log_statement = "#ifdef DEBUG\n\tNSLog(@\"%@: %@\", NSStringFromClass([self class]), NSStringFromSelector(_cmd));\n#endif\n"

def bark input
  filename  = File.basename input
  directory = File.dirname  input
  
  output = File.open(directory + "/" + filename, "w")

  File.open(input, "r").each_line do |line|
    if /^[-|+]/ =~ line
      if line.include? "{"
        output.write(line)
        output.write($log_statement)
      else
        output.write(line)

        lookahead = input.readline

        if lookahead.include? "{"
          output.write(lookahead)
          output.write($log_statement)
        else
          while !lookahead.include? "{"
            output.write(lookahead)
            lookahead = input.readline
          end

          output.write(lookahead)
          output.write($log_statement)
        end
      end
    else
      output.write(line)
    end
  end

  puts "#{File.basename output} generated, located at #{File.dirname output}"
end
