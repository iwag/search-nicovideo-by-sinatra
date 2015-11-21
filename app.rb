require 'sinatra'
require 'nicosearch'

get '/' do
  erb :search
end

get '/search' do
  keyword = params[:q]
  hits = []
  if (keyword != nil && !keyword.empty?) 
    qb = SearchNicovideo::QueryBuilder.new()
    filters =  []
    q = qb.query(keyword).service(["video"]).targets(["title","description"])
      .fields(["title","description","startTime","contentId", "thumbnailUrl"])
      .size(10).from(0)
      .filters(filters).sort("startTime").build
    hits = SearchNicovideo::search(q)["data"]
  end
  erb :search, locals: {keyword: keyword, hits: hits}
end

