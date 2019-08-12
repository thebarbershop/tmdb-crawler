class Tv < ApplicationRecord
    has_many :credit_tvs
    has_many :people, :through => :credit_tvs

    # tv_id에 해당하는 TV시리즈의 정보를 읽어서 관련 정보를 tvs, credit_tvs, people 테이블에 입력
    def self.create_tv tv_id
        include CrawlUtils

        # http get으로 조회
        res = CrawlUtils.http_get CrawlUtils.uri_get_tv_details tv_id
        if not res
            puts "#{tv_id} / TMDB에서 TV시리즈 조회 실패"
            return nil
        end

        if Tv.where(:id => tv_id).exists?
            puts "#{tv_id} / #{res["name"]} / tvs 테이블에 이미 존재"
            return nil
        end

        # people 테이블에 새로운 레코드로 id, name 입력
        tv = Tv.new(id: tv_id, title: res["name"])

        # 해당 TV시리즈의 크레딧 정보 조회
        CreditTv.create_all_credit_tv tv_id
        tv.save
        puts "#{tv_id} / #{res["name"]} / tvs 테이블에 입력 완료"
        return tv
    end
end