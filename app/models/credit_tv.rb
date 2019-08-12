class CreditTv < ApplicationRecord
    belongs_to :person
    belongs_to :tv

    # tv_id에 해당하는 TV시리즈의 크레딧 정보를 읽어서 관련 정보를 credit_tvs, people 테이블에 입력
    def self.create_all_credit_tv tv_id
        include CrawlUtils
        res = CrawlUtils.http_get CrawlUtils.uri_get_tv_credits tv_id
        if not res
            puts "#{tv_id} / TMDB에서 TV시리즈 크레딧 정보 조회 실패"
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
                    # 해당 인물을 크레딧을 credit_tvs 테이블에 등록
                    credit_tv = CreditTv.new(role: crew_or_cast, tv_id:tv_id, person_id:credit["id"])
                    credit_tv.save!
                    puts "role: #{crew_or_cast}, person_id: #{credit["id"]}, tv_id: #{tv_id} / credit_tvs 테이블에 크레딧 정보 입력 완료"
                rescue ActiveRecord::RecordNotUnique
                    next
                end
            end
        end
        puts "#{tv_id} / credit_tvs 테이블에 TV시리즈 크레딧 정보 입력 완료"
    end
end
