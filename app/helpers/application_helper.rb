module ApplicationHelper
  # Marks the current menu item as active.
  def nav_link(label, path)
    active = current_page?(path)
    link_to label, path, class: "nav-link#{' active' if active}", aria: { current: (active ? "page" : nil) }
  end

  def yes_no(value)
    value ? "Yes" : "No"
  end

  def stars(rating)
    "★" * rating.to_i + "☆" * (5 - rating.to_i)
  end
end
