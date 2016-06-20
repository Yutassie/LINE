# -*- coding: utf-8 -*- #

require 'natto'


#-----------------------#

class Lexsearcher
	def initialize(infile)
		@data = []
		@datanum = 0
		infile.each_line do |line|
			@data[@datanum] = line
			@datanum = @datanum + 1
		end
	end
	#«‘‚©‚çŒŸõ
	def searchdic
		nm = Natto::MeCab.new
		@data.size.times do |i|
				nm.parse(@data[i]) do |n|
				$outfile.puts "#{n.surface}"
				#$outfile.puts @data[i]
			end
		end
	end
end

#-----------------------#
$outfile = File.open('keywords_2.txt', 'a')
file = File.open('Candidate_2.txt', 'r') 
s = Lexsearcher.new(file)
s.searchdic

file.close
$outfile.close

#prefile = File.open('keywords2.txt', 'r:UTF-8:SHIFT_JIS')
#nexfile = File.open('keywords.txt', 'w') 
#prefile.each_line do |line|
#	if (line.chomp != "")
#		nexfile.puts line.strip
#	end
#end

