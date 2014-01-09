module ApplicationHelper
  def display_url(url)
    url.starts_with?("http://") ? str : "http://#{url}"
  end

  def format_time(time)
    time.strftime("%d/%m/%Y %I:%M%p %Z")
  end
end
