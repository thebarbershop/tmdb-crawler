require_relative 'utils/crawl_utils.rb'

# 커맨드 라인으로 받은 파라미터에 해당하는 TV시리즈 정보 조회
tv_id = ARGV[0]
Tv.create_tv tv_id
