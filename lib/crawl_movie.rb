require_relative 'crawl_utils.rb'

# movie_id에 해당하는 영화의 정보를 읽어서 관련 정보를 movies, credit_movies, people 테이블에 입력
def get_movie movie_id
    # http get으로 조회
    res = CrawlUtils.http_get CrawlUtils.uri_get_movie_details movie_id
    if not res
        return "#{movie_id} / TMDB에서 영화 조회 실패"
    end
    begin
        # people 테이블에 새로운 레코드로 id, name 입력
        movie = Movie.create(id: movie_id, title: res["title"])
    rescue ActiveRecord::RecordNotUnique
        return "#{movie_id} / #{res["title"]} / movies 테이블에 이미 존재"
    end

    # 해당 영화의 크레딧 정보 조회
    get_credit_movie movie_id
    return "#{movie_id} / #{res["title"]} / movies 테이블에 입력 완료"
end

# movie_id에 해당하는 영화의 크레딧 정보를 읽어서 관련 정보를 credit_movies, people 테이블에 입력
def get_credit_movie movie_id
    res = CrawlUtils.http_get CrawlUtils.uri_get_movie_credits movie_id
    if not res
        return "#{movie_id} / TMDB에서 영화 크레딧 정보 조회 실패"
    end

    ["crew", "cast"].each do |crew_or_cast|
        # 인물 정보 조회
        if res.key?(crew_or_cast)
            res[crew_or_cast].each do |credit|
                # id가 없으면 데이터베이스에 넣을 수 없다.
                if not credit.key?("id")
                    next
                end
                # 해당 크루를 people 테이블에 등록
                puts CrawlUtils.get_person credit["id"]
                begin
                    # 해당 크루의 크레딧을 credit_movies 테이블에 등록
                    credit_movie = CreditMovie.create(role: crew_or_cast, movies_id:movie_id, people_id:credit["id"])
                    puts "role: #{crew_or_cast}, people_id: #{credit["id"]}, movies_id: #{movie_id} / credit_movies 테이블에 크레딧 정보 입력 완료"
                rescue ActiveRecord::RecordNotUnique
                    next
                end
            end
        end
    end
    return "#{movie_id} / credit_movies 테이블에 영화 크레딧 정보 입력 완료"
end

# 커맨드 라인으로 받은 파라미터에 해당하는 영화 정보 조회
movie_id = ARGV[0]
puts get_movie movie_id
