# encoding: utf-8

# ほとんど　http://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/#7　にあるコードのコピペです

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
url = 'http://umie.jp/news/event/'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

doc.xpath('//div[@class="eventNewsBox"]').each do |node|
	# タイトルを表示
	p node.css('h3').inner_text
	p node.css('img').attribute('src').value
	p node.css('a').attribute('href').value
end