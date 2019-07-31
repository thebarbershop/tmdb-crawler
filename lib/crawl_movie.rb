require_relative 'crawl_utils.rb'

# movie_id에 해당하는 영화의 정보를 읽어서 관련 정보를 movies, credit_movies, people 테이블에 입력
def get_movie movie_id
    # http get으로 조회
    movie_res = CrawlUtils.http_get (CrawlUtils.uri_get_movie_details movie_id)
    if not movie_res
        return "TMDB에서 조회 실패"
    end
    begin
        # people 테이블에 새로운 레코드로 id, name 입력
        movie = Movie.create(id: movie_id, title: movie_res["title"])
    rescue ActiveRecord::RecordNotUnique
        return "#{movie_res["title"]} / 데이터베이스에 이미 존재"
    end

    # 해당 영화의 크레딧 정보 조회
    get_credit_movie movie_id
    return "#{movie_res["title"]} / 데이터베이스에 입력 완료"
end

# movie_id에 해당하는 영화의 크레딧 정보를 읽어서 관련 정보를 credit_movies, people 테이블에 입력
def get_credit_movie movie_id
end

# 커맨드 라인으로 받은 파라미터에 해당하는 영화 정보 조회
movie_id = ARGV[0]
res = get_movie movie_id
p "##{movie_id} / #{res}"
