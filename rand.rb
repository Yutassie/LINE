# -*- encoding: utf-8 -*- 

require 'open-uri'
require 'capybara/poltergeist'
require 'nokogiri'
require 'natto'


Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 5000 })
end

#-----------------------#

class Accesstokey
	def initialize
		@session = Capybara::Session.new(:poltergeist)
		@session.driver.headers = {
			'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
		}
	end
	
	def goo(key)
		# keywordをエンコードしてグーグル検索
		@keyword_en = CGI.escape(key)
		 @session.visit "https://www.google.co.jp/search?q=" + @keyword_en
		File.write("out.txt", @session.html)
		return @session.html
	end
	
end

class Parseurl
	def initialize(html, charset)
		# htmlをパース(解析)してオブジェクトを生成
		@doc = Nokogiri::HTML.parse(html, nil, charset)
		@urlindex = 0
		@urllist = []
		@meta = []
	end
	
	def getword
		nodenum = 0
		@doc.xpath('//*[@id = "brs"]/div[@class = "card-section"]/div[@class="brs_col"]/p').each do |node|
			@meta[nodenum] = node.css('a').text
			if(@pre != @meta[nodenum])
				return @meta[nodenum]
			end
		end
		return "-"
		#nilnode = @doc.xpath('//hsjdhgd')
		#File.write("out.txt", @meta[0])
		
	end
end

class Getrand #//*[@id="brs"]/div/div[1]/p[1]/a
	def initialize(key)
		@data = key
		@datanum = [130000]
		@next = []
		@memory = []
		@endflag = 0
	end

	#辞書から検索
	def searchdic
		nm = Natto::MeCab.new
		@data.size.times do |i|
			nm.parse(@data) do |n|
				@next[n] = "#{n.surface}"
			end
			@memory = @data
			n.times do |l|
				if (@next[l] != @data)
					return @next
				elsif (n == n-1)
					if (@memory == @data)
						@endflag = 1
						##@data = $file.readlines[s]
					end
				end
				
				if (@endflag == 1)
					break
				end
				
			end
			
		end
	end
end

class Search < Parseurl
	def initialize(key)
		
		@html = $ac.goo(key)
		super(@html, nil)
	end
	def acURL
		return getword
		#meta.count.times do |i|
		#	$outfile.puts meta[i]
		#end
	end
end


#-----------------------#
$sessionflag = 0
$outfile = File.open('yutassiedic_4.txt', 'a')
$file = File.open('yutassiedic.txt', 'r') 

$ac = Accesstokey.new
time = 0
$file.each_line do |line|
	
	if (line.chomp != "")
		keyword = line.chomp
		1.times do |d|
			s = Search.new(keyword)
			g = Getrand.new(keyword)
			
			meta = s.acURL
			
			if(meta != "-")
				$outfile.puts keyword + "\t" + meta.encode('Windows-31J')
			else
				break
			end
		end
	end
end
