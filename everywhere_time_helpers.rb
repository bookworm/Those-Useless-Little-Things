##
# Global time helpers. WARNING these will polute your namespace. 
# In allot of uses cases its best to wrap them in the Sinatra module or Rails helpers etc.
#

# Takes time in seconds and returns coutdown formatted string
# requires Chronic Duraction 
def countdown(time)  
  time = time - Time.now
  time = time.to_i
  time = ChronoDuration.output(time, :format => :chrono)
  time = time.split(':')
  return time
end         

def timeago(time, options = {})
  start_date = options.delete(:start_date) || Time.new
  date_format = options.delete(:date_format) || :default
  delta_minutes = (start_date.to_i - time.to_i).floor / 60
  if delta_minutes.abs <= (8724*60)       
    distance = distance_of_time_in_words(delta_minutes)       
    if delta_minutes < 0
       return "#{distance} from now"
    else
       return "#{distance}"
    end
  else
     return "on #{DateTime.now.to_formatted_s(date_format)}"
  end
end  

def distance_of_time_in_words(minutes)
  case
    when minutes < 1
      "just now" 
    when minutes < 2
      "1 minute ago" 
    when minutes < 50
      "#{pluralize(minutes, "minute")} ago"
    when minutes < 90
      "1 hour ago"
    when minutes < 1080
      "#{(minutes / 60).round} hours ago"
    when minutes < 1440
      "Yesterday"
    when minutes < 10080  
        "#{(minutes / 1440).round} days ago"
    else
      "#{(minutes / 10080).round} weeks ago"
  end
end  

def time_span(time)
  time = time.split(//)       
  content = ""                                                              
  content << tag('span', :content => time[0],  :class => "num num_#{time[0]} first")  
  content << tag('span', :content => time[1],  :class => "num num_#{time[1]} last")  
  return content
end