module LayoutHelper
  def row(c=nil, &block)
    (<<-eos
    <div class="row #{c}">
    #{capture(&block)}
    </div>
    eos
    ).html_safe
  end

  def col(n, &block)
    (<<-eos
    <div class="col-md-#{n}">
    #{capture(&block)}
    </div>
    eos
    ).html_safe
  end

  def big_link(label, target, t, icon=nil)
    if target.is_a?(String) || target.is_a?(ActiveRecord::Base)
      link_to(target, class: "btn btn-big btn-block btn-#{t}#{icon ? '' : ' btn-big-text'}") do
        (icon ? fa_icon(icon) + ' ' : '') + label
      end
    else
      button_tag(class: "btn btn-big btn-block btn-#{t}#{icon ? '' : ' btn-big-text'}", data: target) do
        (icon ? fa_icon(icon) + ' ' : '') + label
      end
    end
  end

  def action_row(*items)
    items.keep_if{|i| i.present?}
    r = items.count / 6 + (items.count % 6 == 0 ? 0 : 1)
    rows = []
    items.in_groups_of(6) do |c|
      rows << c.delete_if{|x| x.nil? || x.empty?}
    end
    content = ''

    rows.each do |row|
      width = case row.count
      when 1..2
        6
      when 3
        4
      when 4
        3
      when 5..6
        2
      end
      content << %Q{<div class="row actions">\n}
      row.each do |item|
        content << %Q{<div class="col-md-#{width}">\n}
        content << item
        content << "</div>\n"
      end
      content << "</div>\n"
    end

  content.html_safe
  end
end
