# tmdb-query

__NOTE: This is a project in progress. It does not work at this moment.__

[더 무비 데이터베이스(TMDB)][TMDB] API를 이용해 MySQL 데이터베이스에 영화, 텔레비전쇼, 인물 테이블을 구축하는 루비 온 레일즈 어플리케이션.

![The Movie DB](https://www.themoviedb.org/assets/2/v4/logos/408x161-powered-by-rectangle-blue-10d3d41d2a0af9ebcb85f7fb62ffb6671c15ae8ea9bc82a2c6941f223143409e.png)

## 개발 환경

Ubuntu 18.04에서 개발 및 테스트하였다.

- rvm 1.29.9
- Ruby 2.5.3
- Bundler 2.0.1
- Rails 5.2.3
- MySQL 5.6

## 데이터베이스 구조

- 안정적인 개발을 위해 데이터베이스는 tmdb_query_development (개발용), tmdb_query_production (배포용), tmdb_query_test (테스트용)으로 구분하여 이용
- 디폴트로 개발용 서버를 이용
- 데이터베이스는 movie, credit_movie, tv, credit_tv, person의 다섯 테이블로 구성

    ![database scheme](docs/db.png)

    - 영화 제목 영문명의 최대 길이는 255자를 넘지 않는다고 가정 (참고자료 [#1 IMDB의 유저 생성 리스트][long-movie-title-imdb], [#2 TvTropes의 관련 항목][long-movie-title-tvtropes])
    - 텔레비전 시리즈 제목 영문명의 최대 길이는 255자를 넘지 않는다고 가정 (참고자료 [#1 TvTropes의 관련 항목][long-tv-title-tvtropes], [#2 Digital Spy 포럼의 질문글][long-tv-title-digitalspy])

## 환경 구축 절차

Ruby와 MySQL 환경이 구축되지 않은 경우 [해당 문서](docs/environment.md) 참고

## 실행 방법

테스트 환경에서 실행할 경우, 각 명령 뒤에 `-e test` 옵션을 지정

### 영화 정보 크롤

- 실행 명령

    ```sh
    rails runner lib/crawl_movie.rb <movie_id>
    ```

- 예시

    ```sh
    $ rails runner lib/crawl_movie.rb 150
    Running via Spring preloader in process 26032
    1723 / Walter Hill / people 테이블에 입력 완료
    role: crew, people_id: 1723, movies_id: 150 / 크레딧 정보 입력 완료
    1091 / Joel Silver / people 테이블에 입력 완료
    role: crew, people_id: 1091, movies_id: 150 / 크레딧 정보 입력 완료
    (중략)
    1289395 / Bjaye Turner / people 테이블에 입력 완료
    role: cast, people_id: 1289395, movies_id: 150 / 크레딧 정보 입력 완료
    181343 / Begonya Plaza / people 테이블에 입력 완료
    role: cast, people_id: 181343, movies_id: 150 / 크레딧 정보 입력 완료
    150 / 48 Hrs. / movies 테이블에 입력 완료
    ```

### TV시리즈 정보 크롤

- 실행 명령

    ```sh
    rails runner lib/crawl_tv.rb <tv_id>
    ```

- 예시

    ```sh
    $ rails runner lib/crawl_tv.rb 150
    Running via Spring preloader in process 26357
    1213841 / Jane Fallon / people 테이블에 입력 완료
    role: crew, people_id: 1213841, tvs_id: 150 / 크레딧 정보 입력 완료
    21841 / Tony Garnett / people 테이블에 입력 완료
    role: crew, people_id: 21841, tvs_id: 150 / 크레딧 정보 입력 완료
    1213842 / Edwina Craze / people 테이블에 입력 완료
    (중략)
    1213838 / Juliet Cowan / people 테이블에 입력 완료
    role: cast, people_id: 1213838, tvs_id: 150 / 크레딧 정보 입력 완료
    1213839 / Daniela Nardini / people 테이블에 입력 완료
    role: cast, people_id: 1213839, tvs_id: 150 / 크레딧 정보 입력 완료
    150 / This Life / tvs 테이블에 입력 완료
    ```

[RVM]: https://rvm.io
[TMDB]: https://www.themoviedb.org
[long-movie-title-imdb]: https://www.imdb.com/list/ls064443882/
[long-movie-title-tvtropes]: https://tvtropes.org/pmwiki/pmwiki.php/LongTitle/Film
[long-tv-title-tvtropes]: https://tvtropes.org/pmwiki/pmwiki.php/Main/LongTitle
[long-tv-title-digitalspy]: https://forums.digitalspy.com/discussion/2176058/tv-show-movie-with-the-longest-name
