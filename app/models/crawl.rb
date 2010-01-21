require 'open-uri'
require 'net/http'

class Crawl < ActiveRecord::Base
  BASE_URL = 'http://www.youtube.com'
  BASE_VIDEOS_URL = "#{BASE_URL}/videos"
  BASE_QUERY = '?lg=EN&s=mp&t=a'
  MAX_PAGES = 10 # Parse this many pages max
  
  
  def self.seed_crawl_if_required
    return if Crawl.first
    Crawl.new(:urls => '').save
  end

  def self.clear_crawl
    Crawl.first.update_attribute(:urls, "")
  end
  
  # You can limit the amount of crawled cities by passing in a number > 0
  def self.update_crawl(limit_crawled_cities = 0)
    seed_crawl_if_required
    report = []
    
    next_query = BASE_QUERY
    (0..MAX_PAGES).each do |i|
      break unless next_query
      page = Hpricot(open("#{BASE_VIDEOS_URL}#{next_query}"))
      logger.debug "#{i}. Opened #{URL}"
      report.concat(parse_videos_div(page/'#browse-video-data'))

      next_a = (page/'div.pagingDiv a:last')
      next_query = next_a && next_a.attributes['href'].index('Next') ? next_a.attributes['href'] : nil
    end
    
    logger.debug "FOUND #{report.size} VIDEOS"
    
    ####### SEND REPORT
    # Riveti::Api.send_videos(report) if report.size > 0
    
    report
    
  rescue OpenURI::HTTPError => e
    logger.error "FATAL ERROR: Couldn't open base URL '#{URL}' because of an HTTP Error. #{e}"
    raise
  end
  
  def self.parse_videos_div(videos_div)
    parsed_videos = []
    video_links = (videos_div/'div.video-entry > a')
    video_links.each do |video_a|
      runtime_text = (video_a/'.video-time').inner_text
      parsed_videos << parse_video_url(url, runtime_text) unless Crawl.first.urls.include?(url)
    end
    
    parsed_videos
  end
  
  def self.parse_video_url(video_url, runtime_text)
    page = Hpricot(open("#{BASE_URL}#{video_url}"))
    # Make nil checking easier
    category = (page/'a#watch-video-category')[0]
    description = (page/'#watch-video-details-inner-more div.description')
    views_count = (page/'#watch-view-count')
    ratings_count = (page/'#defaultRatingMessage')
    comments_count = (page/'#watch-comment-panel h4 span.expander-head-stat')
    popularity_count = (views_count ? views_count.inner_text.gsub(/,/, '').to_i : 0) + (ratings_count ? ratings_count.inner_text.gsub(/,/, '').to_i : 0) + (comments_count ? comments_count.inner_text.gsub(/\(/, '').gsub(/\)/, '').gsub(/,/, '').to_i : 0)
    
    details => {
      :category_name => category ? category.inner_text : nil,
      :name => (page/'#watch-vid-title h1').inner_text,
      :url => "#{BASE_URL}#{video_url}",
      :vid => video_url['/watch?v='.length..-1],
      :description => description ? description.inner_text : nil,
      :popularity_rank => popularity_count,
      :length_in_seconds => convert_string_to_seconds(runtime_text)
    }
    
    Crawl.first.update_attribute(:urls, "#{event_url}|#{Crawl.first.urls}")
  
    details
  end
  
  def self.convert_string_to_seconds(time_string)
    time_array = time_string.split(':')
    if time_array.size == 3
      return time_array[0] * 60 * 60 + time_array[1] * 60 + time_array[2]
    elsif time_array.size == 2
      return time_array[0] * 60 + time_array[1]
    elsif time_array.size == 1
      return time_array[0]
    else
      return 0
    end
  end
  

end
