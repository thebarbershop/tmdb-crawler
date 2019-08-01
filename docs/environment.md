# 환경 구축

## 설치

1. 본 git 저장소를 다운로드한다.

    ```sh
    git clone https://github.com/thebarbershop/tmdb-query.git
    cd tmdb-query
    ```

1. (필요한 경우) 다음 스크립트를 실행하여 RVM을 설치한다.

    ```sh
    sudo chmod +755 install-rvm.sh
    ./install-rvm.sh
    ```

    - 시스템을 재시작한다.

1. (필요한 경우) 다음 명령을 실행하여 Ruby 2.5.3와 Bundler 2.0.1을 설치한다.

    ```sh
    sudo chmod +755 install-ruby.sh
    ./install-ruby.sh
    ```

1. (필요한 경우) 다음 스크립트를 실행하여 MySQL 5.6.45를 설치한다.

    ```sh
    sudo chmod +755 install-mysql.sh
    ./install-mysql.sh
    ```

1. bundler를 이용하여 본 어플리케이션에 필요한 gem을 설치한다.

    ```sh
    bundle install
    ```

## 실행

1. MySQL 서버를 실행한다.

    ```sh
    sudo /usr/local/mysql/bin/mysqld_safe &
    ```

2. 개발 환경 또는 테스트 환경에서 Rails를 실행한다.

    - 개발 환경

    ```sh
    sudo chmod +755 -R mysql-5.6.45-linux-glibc2.12-x86_64/
    rake db:create
    rails db:migrate
    rails server
    ```

    - 테스트 환경

    ```sh
    sudo chmod +755 -R mysql-5.6.45-linux-glibc2.12-x86_64/
    rake test:prepare
    rake db:create
    rails db:migrate RAILS_ENV=test
    rails server -e test
    ```
