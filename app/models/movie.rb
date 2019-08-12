class Movie < ApplicationRecord
    has_many :credit_movies
    has_many :people, :through => :credit_movies

    # movie_id에 해당하는 영화의 정보를 읽어서 관련 정보를 movies, credit_movies, people 테이블에 입력
    def self.create_movie movie_id
        include CrawlUtils

        # http get으로 조회
        res = CrawlUtils.http_get CrawlUtils.uri_get_movie_details movie_id
        if not res
            puts "#{movie_id} / TMDB에서 영화 조회 실패"
            return nil
        end

        if Movie.where(:id => movie_id).exists?
            puts "#{movie_id} / #{res["title"]} / movies 테이블에 이미 존재"
            return nil
        end

        # people 테이블에 새로운 레코드로 id, name 입력
        movie = Movie.new(id: movie_id, title: res["title"])
        movie.save!

        # 해당 영화의 크레딧 정보 조회
        CreditMovie.create_all_credit_movie movie_id
        puts "#{movie_id} / #{res["title"]} / movies 테이블에 입력 완료"
        return movie
    end
end
