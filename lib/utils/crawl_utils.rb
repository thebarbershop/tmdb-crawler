module CrawlUtils
    require "net/http"
    require "json"

    require_relative 'crawl_config.rb'

    # 각 API를 호출할 수 있는 URI를 생성하는 메소드
    def self.uri_get_person_details person_id
        safe_format CrawlConfig.tmdb_api_get_person_details, person_id
    end
    def self.uri_get_movie_details movie_id
        safe_format CrawlConfig.tmdb_api_get_movie_details, movie_id
    end
    def self.uri_get_movie_credits movie_id
        safe_format CrawlConfig.tmdb_api_get_movie_credits, movie_id
    end
    def self.uri_get_tv_details tv_id
        safe_format CrawlConfig.tmdb_api_get_tv_details, tv_id
    end
    def self.uri_get_tv_credits tv_id
        safe_format CrawlConfig.tmdb_api_get_tv_credits, tv_id
    end

    ## URI에 GET을 요청하고 응답을 반환
    def self.http_get uri
        uri = URI(uri)
        uri.query = URI.encode_www_form({
            :api_key => CrawlConfig.api_key,
        })
        res = Net::HTTP.get_response(uri)

        # 응답이 Success인 경우에만 JSON을 파싱해서 반환
        # 그 외의 경우 nil 반환
        return JSON[res.body] if res.is_a?(Net::HTTPSuccess)
    end

    # "%s"가 포함된 문자열을 받아서 id가 정수 혹은 정수꼴 문자열인 경우에만 포매팅하여 반환
    def self.safe_format unformatted_str, id
        if id.to_i.to_s == id or id.to_s.to_i == id
            unformatted_str % id
        else
            unformatted_str % ""
        end
    end
end
