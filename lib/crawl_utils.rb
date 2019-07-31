require "net/http"
require "json"

class Config
    # TMDB API 키는 파일로 보관
    @@api_key = File.read("./dev/api.key").strip
    def self.api_key
        @@api_key
    end

    # 각 API마다 URI를 상수로 저장
    tmdb_api_base = "https://api.themoviedb.org/3"
    @@tmdb_api_get_person_details = tmdb_api_base + "/person/%s"
    @@tmdb_api_get_movie_details = tmdb_api_base + "/movie/%s"

    def self.tmdb_api_get_person_details
        @@tmdb_api_get_person_details
    end
    def self.tmdb_api_get_movie_details
        @@tmdb_api_get_movie_details
    end
end

class CrawlUtils
    def self.uri_get_person_details person_id
        return safe_format Config.tmdb_api_get_person_details, person_id
    end
    
    def self.uri_get_movie_details movie_id
        return safe_format Config.tmdb_api_get_movie_details, movie_id
    end

    # person_id에 해당하는 인물의 정보를 읽어서 people 테이블에 입력
    def self.get_person person_id
        res = http_get (uri_get_person_details person_id)
        if not res
            # 실패한 응답은 무시
            return
        end
        begin
            # people 테이블에 새로운 레코드로 id, name 입력
            person = Person.create(id: person_id, name: res["name"])
            return res
        rescue ActiveRecord::RecordNotUnique
            # 이미 입력되어 있으면 무시
            return
        end
    end

    ## URI에 GET을 요청하고 응답을 반환
    def self.http_get uri
        uri = URI(uri)
        uri.query = URI.encode_www_form({
            :api_key => Config.api_key,
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