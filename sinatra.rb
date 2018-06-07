require 'sinatra'
require 'sinatra/reloader'
require 'httparty'
require 'nokogiri'
require 'json'

get '/menu' do
    
    # 점심에는 ? 을 먹고 저녁에는 ? 을 드세요
    # 조건: .sample함수는 1번만 사용가능
    menu = ["20층", "순남시래기", "김밥카페", "시골집", "순대국"]
    result = menu.sample(2)
    
    "점심에는 " + result[0] + " 를 드시고 저녁에는 " + result[1] + " 를 드세요."
end

get '/lotto' do
    # 출력: 이번주 추천 로또 숫자는 
    # n1, n2, n3, n4, n5, n6 입니다.
    numbers = *(1..45)
    lotto = numbers.sample(6).sort
    
    "이번주 추천 로또 숫자는 " + lotto.to_s + " 입니다."
end

get '/check_lotto' do
    url = "http://m.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    lotto = HTTParty.get(url)
    result = JSON.parse(lotto)
    numbers = []
    bonus = result["bnusNo"]
    result.each do |k, v|
        if k.include?("drwtNo")
            numbers << v
        end
    end
    count = 0
    check_bonus = true
    while(count < 6 and check_bonus)
        my_numbers = *(1..45)
        my_lotto = my_numbers.sample(6).sort
        
        numbers.each do |num|
            count += 1 if my_lotto.include?(num)
        end
        msg = "#{count}개 맞추셨습니다. \n"
        case count
        when 6
            msg = msg + "미쳤다리.. 1등임.. 이게뭐야 ㅠㅠ"
        when 5
            if numbers.include?(bonus)
                check_bonus = false
                msg = msg + "미쳤.. 님 방금 4천만원 날림 ㅎㅎ"
            else
                msg = msg + "여기부터 미련없음 3등임"
            end
        when 4
            msg = msg + "4등임 5만원!! ㅊㅋㅊㅋ"
        when 3
            msg = msg + "5등임.. 본전인가?"
        else
            msg = msg + "축하합니다 꽝입니다!!"
        end
    end
    msg
end

get '/kospi' do
    response = HTTParty.get("http://finance.daum.net/quote/kospi.daum")
    kospi = Nokogiri::HTML(response)
    result = kospi.css("#hyenCost > b")
    "현재 코스피 지수는" + result.text + " 포인트입니다." 
end

get '/html' do
    "<html>
        <head></head>
        <body>
            <h1>안녕하세요?</h1>
        </body>
    </html>"
end

get '/html_file' do
    @name = params[:name]
    name = "Hoho"
    erb :my_first_html
end

get '/calculate' do
    n1 = params[:num1].to_i
    n2 = params[:num2].to_i
    @sum = n1 + n2
    @min = n1 - n2
    @mul = n1 * n2
    @div = n1 / n2
    
    erb :calculate
end
