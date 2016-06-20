# encoding: utf-8

# �قƂ�ǁ@http://morizyun.github.io/blog/ruby-nokogiri-scraping-tutorial/#7�@�ɂ���R�[�h�̃R�s�y�ł�

# URL�ɃA�N�Z�X���邽�߂̃��C�u�����̓ǂݍ���
require 'open-uri'
# Nokogiri���C�u�����̓ǂݍ���
require 'nokogiri'

# �X�N���C�s���O���URL
url = 'http://umie.jp/news/event/'

charset = nil
html = open(url) do |f|
  charset = f.charset # ������ʂ��擾
  f.read # html��ǂݍ���ŕϐ�html�ɓn��
end

# html���p�[�X(���)���ăI�u�W�F�N�g�𐶐�
doc = Nokogiri::HTML.parse(html, nil, charset)

doc.xpath('//div[@class="eventNewsBox"]').each do |node|
	# �^�C�g����\��
	p node.css('h3').inner_text
	p node.css('img').attribute('src').value
	p node.css('a').attribute('href').value
end