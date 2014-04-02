module ApplicationHelper
  def display_url(url)
    url.starts_with?("http://") ? str : "http://#{url}"
  end

  def format_time(time)
    if logged_in? && !current_user.time_zone.blank?
      time = time.in_time_zone(current_user.time_zone)
    end
    time.strftime("%d/%m/%Y %I:%M%p %Z")
  end

  def sorted_by_votes(collection)
    collection.sort_by{|x| x.total_votes }.reverse
  end
end
