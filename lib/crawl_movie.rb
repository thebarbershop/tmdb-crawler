require_relative 'crawl_utils.rb'

# movie_id에 해당하는 영화의 정보를 읽어서 관련 정보를 movies, credit_movies, people 테이블에 입력
def get_movie movie_id
    # http get으로 조회
    res = CrawlUtils.http_get CrawlUtils.uri_get_movie_details movie_id
    if not res
        return "TMDB에서 조회 실패"
    end
    begin
        # people 테이블에 새로운 레코드로 id, name 입력
        movie = Movie.create(id: movie_id, title: res["title"])
    rescue ActiveRecord::RecordNotUnique
        return "#{res["title"]} / 데이터베이스에 이미 존재"
    end

    # 해당 영화의 크레딧 정보 조회
    get_credit_movie movie_id
    return "#{res["title"]} / 데이터베이스에 입력 완료"
end

# movie_id에 해당하는 영화의 크레딧 정보를 읽어서 관련 정보를 credit_movies, people 테이블에 입력
def get_credit_movie movie_id
    res = CrawlUtils.http_get CrawlUtils.uri_get_movie_credits movie_id
    if not res
        return "TMDB에서 조회 실패"
    end
    # 크루 정보 조회
    if res.key?("crew")
        res["crew"].each do |crew|
            # id가 없으면 데이터베이스에 넣을 수 없다.
            if not crew.key?("id")
                next
            end
            # 해당 크루의 크레딧을 credit_movies 테이블에 등록
            begin
                # 해당 크루를 people 테이블에 등록
                CrawlUtils.get_person crew["id"]
                credit_movie = CreditMovie.create(role: "crew", movies_id:movie_id, people_id:crew["id"])
            rescue ActiveRecord::RecordNotUnique
                next
            end
        end
    end
    # 캐스트 정보 조회
    if res.key?("cast")
        res["cast"].each do |cast|
            # id가 없으면 데이터베이스에 넣을 수 없다.
            if not cast.key?("id")
                next
            end
            # 해당 캐스트의 크레딧을 credit_movies에 등록
            begin
                # 해당 캐스트를 people 테이블에 등록
                CrawlUtils.get_person cast["id"]
                credit_movie = CreditMovie.create(role: "cast", movies_id:movie_id, people_id:cast["id"])
            rescue ActiveRecord::RecordNotUnique
                next
            end
        end
    end
end

# 커맨드 라인으로 받은 파라미터에 해당하는 영화 정보 조회
movie_id = ARGV[0]
res = get_movie movie_id
p "##{movie_id} / #{res}"
