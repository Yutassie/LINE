# -*- encoding: utf-8 -*- 

require 'open-uri'
require 'capybara/poltergeist'
require 'nokogiri'
require 'natto'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 50000 })
end

#-----------------------#

class Accesstourl
	def initialize
		@session = Capybara::Session.new(:poltergeist)
		@session.driver.headers = {
			  'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2564.97 Safari/537.36"
		}
	end
	
	def search(url)
		# urlに接続
		@session.visit url
		
		return @session.html
	end
end

class Parseurl
	def initialize(html, charset)
		# htmlをパース(解析)してオブジェクトを生成
		@doc = Nokogiri::HTML.parse(html, nil, charset)
		@urlindex = 0
		@urllist = []
		@word = []
	end
	def getsearch
		@doc.xpath('//h3[@class="r"]').each do |node|
			# タイトルを表示
			@urllist[@urlindex] = node.css('a').attribute("href").value
			
			# URLをデコード
			@urllist[@urlindex] = URI.escape(@urllist[@urlindex])
			
			@urlindex = @urlindex+1
		end
		return @urllist
	end
	
	
	def getmoreinfo
		nodenum = 0
		f = 0
		node = @doc.xpath('//body/div/table/tbody/tr/td/table/tbody/tr/td/div/center/table/tbody/tr')
		node.xpath('//td[contains(font/a/@href, "http")]/font').each do |no|
			if (f == 0)
				f = 1
			else
				@word[nodenum] = no.css('a').text
				nodenum = nodenum + 1
			end
		end
		
		
		#File.write("out.txt", @word[@word.size-1])
		return @word
	end
	
	def getfishinfo
		p "fish"
		nodenum = 0
		@doc.xpath('//table/tbody/tr/td/ul').each do |node|
			node.css('li').each do |n|
				@word[nodenum] = n.text
				nodenum = nodenum + 1
			end
		end
		
		#File.write("out.txt", @word[@word.size-1])
		return @word
	end
	
	def getbuiltinfo
		p "built"
		nodenum = 0
		@doc.xpath('//tbody').each do |node|
			node.css('tr').each do |n|
				@word[nodenum] = n.css('td[a/@title != nil]/a').text
				nodenum = nodenum + 1
			end
		end
		
		#File.write("out.txt", @word[@word.size-1])
		return @word
	end
	
	def getbuilginginfo
		p "built2"
		nodenum = 0
		@doc.xpath('//tbody').each do |node|
			node.css('tr').each do |n|
				@word[nodenum] = n.css('td[a/@title != nil]/a').text
				nodenum = nodenum + 1
			end
		end
		
		#File.write("out.txt", @word[@word.size-1])
		return @word
	end
end

class Ptofile < Parseurl
	def initialize(url)
		@a = Accesstourl.new
		#@word = Lexanalyzer.new
		@html = @a.search(url)
		super(@html, nil)
	end
	
	def putto(index)
	
		case index
			when 0 then
				@word = getmoreinfo
			when 1 then
				@word = getfishinfo
			when 2 then
				@word = getbuiltinfo
		end
		@word.count.times do |i|
			$file.puts @word[i]
		end
	end
end


#-----------------------#
$file = File.open('Candidate.txt','a')

url = Array.new(["http://www.e-yakusou.com/sou/", "https://ja.wikipedia.org/wiki/%E9%AD%9A%E3%81%AE%E4%B8%80%E8%A6%A7","https://ja.wikipedia.org/wiki/%E4%B8%96%E7%95%8C%E9%81%BA%E7%94%A3%E3%81%AE%E4%B8%80%E8%A6%A7_(%E3%83%A8%E3%83%BC%E3%83%AD%E3%83%83%E3%83%91)","https://ja.wikipedia.org/wiki/%E4%B8%96%E7%95%8C%E9%81%BA%E7%94%A3%E3%81%AE%E4%B8%80%E8%A6%A7_(%E3%82%A2%E3%82%B8%E3%82%A2)"])
ac = Accesstourl.new
p = "0"
s = Ptofile.new(url[0])
p "1"
html = ac.search(url[0])
p "2"
s.putto(0)
p "3"
#maxindex = urlindex-1

#urllist[5]

File.write("out.html", html)
