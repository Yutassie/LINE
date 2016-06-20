# -*- encoding: utf-8 -*- 

require 'open-uri'
require 'capybara/poltergeist'
require 'nokogiri'

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
	
	def search(keyword)
		#keyword =  keyword.encode('Windows-31J','Shift_JIS')
		# keywordをエンコードしてグーグル検索
		@keyword_en = URI.escape(keyword)
		#@keyword_en = URI.escape(@keyword_en)
		#@session.visit "https://www.google.co.jp/search?q=" + @keyword_en
		a = "https://ja.wikipedia.org/wiki/" + @keyword_en
		#a = URI.escape(a)
		p a
		@session.visit a
		File.write("out.html", @session.html)
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
	
	def getflower
		
	end
	
	def getmoreinfo
		# 網目科属を抽出
		node = @doc.xpath('//tr[td/a = "界"]/td[contains(a, "界")][a != "界"]')
		nilnode = @doc.xpath('//hsjdhgd')
		
		if(node.css('a') != nilnode)
			@meta[0] = node.css('a').attribute("title").value
		end
		
		node = @doc.xpath('//tr[td/a = "目"]/td[contains(a, "目")][a != "目"]')
		if(node.css('a') != nilnode)
			@meta[1] = node.css('a').attribute("title").value
		end
		
		node = @doc.xpath('//tr[td/a = "科"]/td[contains(a, "科")][a != "科"]')
		if(node.css('a') != nilnode)
			@meta[2] = node.css('a').attribute("title").value
		end
		
		node = @doc.xpath('//tr[td/a = "属"]/td[contains(a, "属")][a != "属"]')
		if(node.css('a') != nilnode)
			@meta[3] = node.css('a').attribute("title").value
		end
		
		File.write("out.txt", @meta[0])
		return @meta
	end
end

class Searchmeta < Parseurl
	def initialize(key)
		#@a = Accesstokey.new
		
		@html = $ac.search(key)
		super(@html, nil)
	end
	def acURL
		
		meta = getmoreinfo
		
		meta.count.times do |i|
			$outfile.puts meta[i]
		end
	end
end


#-----------------------#
$sessionflag = 0
$outfile = File.open('yutassiedic.txt', 'a')
$file = File.open('keywords.txt', 'r') 

$ac = Accesstokey.new

$file.each_line do |line|

	if (line.chomp != "")
		s = Searchmeta.new(line.chomp)
		s.acURL
		$outfile.puts line
	end
end
