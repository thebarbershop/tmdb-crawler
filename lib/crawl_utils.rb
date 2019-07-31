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
    @@tmdb_api_get_person_details = tmdb_api_base + "/person"
    @@tmdb_api_get_movie_details = tmdb_api_base + "/movie"

    def self.tmdb_api_get_person_details
        @@tmdb_api_get_person_details
    end
    def self.tmdb_api_get_movie_details
        @@tmdb_api_get_movie_details
    end
end

class CrawlUtils
    ## URI에 GET을 요청하고 응답을 반환
    def self.http_get base_uri, id
        # 사용하는 모든 API는 <base_uri>/<id> 꼴의 URI를 가지고 있다.
        uri = URI(base_uri+"/#{id}")
        uri.query = URI.encode_www_form({
            :api_key => Config.api_key,
        })
        res = Net::HTTP.get_response(uri)

        # 응답이 Success인 경우에만 JSON을 파싱해서 반환
        # 그 외의 경우 nil 반환
        return JSON[res.body] if res.is_a?(Net::HTTPSuccess)
    end

    # person_id에 해당하는 인물의 정보를 읽어서 people 테이블에 입력
    def self.get_person person_id
        res = http_get Config.tmdb_api_get_person_details, person_id
        if res
            # people 테이블에 새로운 레코드로 id, name 입력
            person = Person.create(id: person_id, name: res["name"])
            return res
        end
        # 실패한 응답은 무시
    end
end
