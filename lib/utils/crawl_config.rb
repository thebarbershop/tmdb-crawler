module CrawlConfig
    # TMDB API 키는 파일로 보관
    @@api_key = File.read("./dev/api.key").strip

    # 각 API마다 URI를 리터럴로 저장
    tmdb_api_base = "https://api.themoviedb.org/3"
    @@tmdb_api_get_person_details = tmdb_api_base + "/person/%s"
    @@tmdb_api_get_movie_details = tmdb_api_base + "/movie/%s"
    @@tmdb_api_get_movie_credits = tmdb_api_base + "/movie/%s/credits"
    @@tmdb_api_get_tv_details = tmdb_api_base + "/tv/%s"
    @@tmdb_api_get_tv_credits = tmdb_api_base + "/tv/%s/credits"

    # Class variable에 대한 getter 선언
    def self.api_key
        @@api_key
    end
    def self.tmdb_api_get_person_details
        @@tmdb_api_get_person_details
    end
    def self.tmdb_api_get_movie_details
        @@tmdb_api_get_movie_details
    end
    def self.tmdb_api_get_movie_credits
        @@tmdb_api_get_movie_credits
    end
    def self.tmdb_api_get_tv_details
        @@tmdb_api_get_tv_details
    end
    def self.tmdb_api_get_tv_credits
        @@tmdb_api_get_tv_credits
    end
end
