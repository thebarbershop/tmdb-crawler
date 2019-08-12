require_relative 'utils/crawl_utils.rb'

# 커맨드 라인으로 받은 파라미터에 해당하는 영화 정보 조회
movie_id = ARGV[0]
Movie.create_movie movie_id
