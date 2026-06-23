
mode=ARGV.first
raise "ERROR : I need either 'enonces' or 'solutions'" unless ["enonces","solutions"].include?(mode)

puts "mode : #{mode}"

Dir["td_*/td_*.tex"].each do |latex|
  puts "[+] processing #{latex}"
  dirname =File.dirname(latex)
  basename=File.basename(latex,'.tex')

  text=IO.readlines(latex)
  new_text=[]
  text.each do |line|
    new_line=line
    case mode
    when "enonces"
      case line
      when /\A\\solutionstrue/ # a commenter
        new_line="%\solutionstrue\n"
      when /\A\%\\solutionsfalse/# a decommenter
        new_line="\\solutionsfalse\n"
      end
    when "solutions"
      case line
      when /\A\\solutionsfalse/# a commenter
        new_line="%\\solutionsfalse\n"
      when /\A\%\\solutionstrue/ # a decommenter
        new_line="\\solutionstrue\n"
      end
    end
    new_text << new_line
  end
  
  new_filename=dirname+"/"+"new_"+basename+".tex"
  File.open(new_filename,'w'){|f| f.puts new_text.join}
  puts " |--[+] saved #{new_filename}"
end
