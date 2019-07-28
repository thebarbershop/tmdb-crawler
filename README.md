# tmdb_crawl

__NOTE: This is a project in progress. It does not work at this moment.__

A Ruby on Rails application to crawl [The Movie Database(TMDB)][TMDB] and make a MySQL database with Movie, TV, and Person tables.

## Environment

- [RVM][RVM]
- Ruby 2.5.3
- Bundler 2.0.1
- Rails 5.2.3
- MySQL 5.6

## Steps to reproduce

### Ubuntu 18.04

1. Run the script to install RVM, Ruby 2.5.3, Bundler 2.0.1.

    ```sh
    sudo chmod +755 install-ruby.sh
    ./install-ruby.sh
    ```

1. Run the script to install MySQL 5.6.45

    ```sh
    sudo chmod +755 install-mysql.sh
    ./install-mysql.sh
    ```

1. Install the gems with bundle.

    ```sh
    gem install rails -v 5.2.3
    gem install mysql2
    ```

[RVM]: https://rvm.io
[TMDB]: https://www.themoviedb.org
