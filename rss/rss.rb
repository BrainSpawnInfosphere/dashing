require 'feedjira'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '5m', :first_in => 0 do |job|
    # Add your own RSS feed URL here. You can find the link on your profile page
    feed = Feedjira::Feed.fetch_and_parse("http://feeds.arstechnica.com/arstechnica/index")

    posts = []
    n = feed.entries.size
    feed.entries.each_with_index do |post, index|
        title = post.title
        summary = post.summary
        published = post.published.strftime("%H:%S on %-d %b")
        posts.push({title: title, summary: summary, published: published, id: index+1, num: n})
    end
    posts

    send_event('rss', { :posts => posts })
end