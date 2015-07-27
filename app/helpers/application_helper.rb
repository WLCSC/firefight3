module ApplicationHelper
  def bootstrap_class code
    case code
    when -9..0
      'info'
    when 1..9
      'success'
    when 10..19
      'danger'
    when 20..29
      'warning'
    else
      'primary'
    end
  end

  def time_delta time
    if time
      if time < Time.now
        distance_of_time_in_words_to_now(time) + " ago"
      else
        distance_of_time_in_words_to_now(time) + " from now"
      end
    else
      'TIME ERROR'
    end
  end

  def nice_datetime d
    d.try(:strftime, ("%l:%M %p %m-%d-%y"))
  end

  def nice_date d
    d.strftime("%m-%d-%y")
  end

  def pills_for collection, klass = nil
    buffer = '<ul class="nav nav-pills ' + (klass ? klass : '') + '">' + "\n"
    collection.each do |item|
      buffer << '<li>' + link_to(item.display, item) + '</li>' + "\n"
    end
    buffer << '</ul>'
    buffer.html_safe
  end

  def markdown text
    Kramdown::Document.new(text).to_html.html_safe
  end

  def targetable_path t
    case t
    when User
      user_path(t.samaccountname)
    when Group
      group_path(t.samaccountname)
    when Room
      building_room_path(t.building, t)
    when Building
      building_path(t)
    when Asset
      asset_path(t)
    when Service
      service_path(t)
    when Topic
      topic_path(t)
    when Consumable
      consumable_path(t)
    end
  end

  def file_type_icon(f)
    case f.file_content_type
    when /image/
      fa_icon 'file-image-o'
    when 'application/pdf'
      fa_icon 'file-pdf-o'
    else
      fa_icon 'file-o'
    end
  end

end
