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
    q = qb.query(keyword).service(["video"]).search(["title","description"])
      .join(["title","description","start_time","content_id", "thumbnail_url"])
      .filters(filters).sort_by("start_time").desc(true).build().to_json
    hits = SearchNicovideo::search(q)[:hits]
    hits = (hits==nil || hits.empty? || hits[0] == nil || hits[0]["values"] == nil) ?  [] : hits[0]["values"]
  end
  erb :search, locals: {keyword: keyword, hits: hits}
end

