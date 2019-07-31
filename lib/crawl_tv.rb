require_relative 'crawl_utils.rb'

# tv_id에 해당하는 TV시리즈의 정보를 읽어서 관련 정보를 tvs, credit_tvs, people 테이블에 입력
def get_tv tv_id
    # http get으로 조회
    res = CrawlUtils.http_get CrawlUtils.uri_get_tv_details tv_id
    if not res
        return "#{tv_id} / TMDB에서 TV시리즈 조회 실패"
    end
    begin
        # people 테이블에 새로운 레코드로 id, name 입력
        tv = Tv.create(id: tv_id, title: res["name"])
    rescue ActiveRecord::RecordNotUnique
        return "#{tv_id} / #{res["name"]} / tvs 테이블에 이미 존재"
    end

    # 해당 TV시리즈의 크레딧 정보 조회
    get_credit_tv tv_id
    return "#{tv_id} / #{res["name"]} / tvs 테이블에 입력 완료"
end

# tv_id에 해당하는 TV시리즈의 크레딧 정보를 읽어서 관련 정보를 credit_tvs, people 테이블에 입력
def get_credit_tv tv_id
    res = CrawlUtils.http_get CrawlUtils.uri_get_tv_credits tv_id
    if not res
        return "#{tv_id} / TMDB에서 TV시리즈 크레딧 정보 조회 실패"
    end

    # 인물은 crew와 cast로 구분
    ["crew", "cast"].each do |crew_or_cast|
        # 인물 정보 조회
        if res.key?(crew_or_cast)
            res[crew_or_cast].each do |credit|
                # id가 없으면 데이터베이스에 넣을 수 없음
                if not credit.key?("id")
                    next
                end
                # 해당 인물을 people 테이블에 등록
                p CrawlUtils.get_person credit["id"]
                begin
                    # 해당 인물을 크레딧을 credit_tvs 테이블에 등록
                    credit_tv = CreditTv.create(role: crew_or_cast, tvs_id:tv_id, people_id:credit["id"])
                    p "role: #{crew_or_cast}, people_id: #{credit["id"]}, tvs_id: #{tv_id} / 크레딧 정보 입력 완료"
                rescue ActiveRecord::RecordNotUnique
                    next
                end
            end
        end
    end
    return "#{tv_id} / TV시리즈 크레딧 정보 입력 완료"
end

# 커맨드 라인으로 받은 파라미터에 해당하는 TV시리즈 정보 조회
tv_id = ARGV[0]
p get_tv tv_id
