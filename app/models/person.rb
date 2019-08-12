class Person < ApplicationRecord
    has_many :credit_movies
    has_many :movies, :through => :credit_movies
    has_many :credit_tvs
    has_many :tvs, :through => :credit_tvs

    # person_id에 해당하는 인물의 정보를 읽어서 people 테이블에 입력
    # return value는 해당 Person record
    def self.create_person person_id
        include CrawlUtils

        # http get으로 조회
        res = CrawlUtils.http_get CrawlUtils.uri_get_person_details person_id
        if not res
            puts "Person #{person_id} / TMDB에서 인물 조회 실패"
            return nil
        end
        begin
            # people 테이블에 새로운 레코드로 id, name 입력
            person = Person.create(id: person_id, name: res["name"])
            puts "Person #{person_id} / #{res["name"]} / people 테이블에 입력 완료"
        rescue ActiveRecord::RecordNotUnique
            # 이미 입력되어 있으면 무시
            puts "Person #{person_id} / #{res["name"]} / people 테이블에 이미 존재"
            return nil
        end
        return person
    end
    
end