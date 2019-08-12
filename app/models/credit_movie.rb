class CreditMovie < ApplicationRecord
    belongs_to :person
    belongs_to :movie

    # movie_id에 해당하는 영화의 크레딧 정보를 모두 읽어서 관련 정보를 credit_movies, people 테이블에 입력
    def self.create_all_credit_movie movie_id
        include CrawlUtils
        res = CrawlUtils.http_get CrawlUtils.uri_get_movie_credits movie_id
        if not res
            puts "#{movie_id} / TMDB에서 영화 크레딧 정보 조회 실패"
            return nil
        end

        # 인물은 crew와 cast로 구분
        ["crew", "cast"].each do |crew_or_cast|
            # 인물 정보 조회
            if not res.key?(crew_or_cast)
                next
            end
            res[crew_or_cast].each do |credit|
                # id가 없으면 데이터베이스에 넣을 수 없음
                if not credit.key?("id")
                    next
                end
                # 해당 인물을 people 테이블에 등록
                Person.create_person credit["id"]
                begin
                    # 해당 인물의 크레딧을 credit_movies 테이블에 등록
                    credit_movie = CreditMovie.new(role: crew_or_cast, movie_id:movie_id, person_id:credit["id"])
                    credit_movie.save!
                    puts "role: #{crew_or_cast}, person_id: #{credit["id"]}, movie_id: #{movie_id} / credit_movies 테이블에 크레딧 정보 입력 완료"
                rescue ActiveRecord::RecordNotUnique
                    next
                end
            end
        end
        puts "#{movie_id} / credit_movies 테이블에 영화 크레딧 정보 입력 완료"
    end
end
