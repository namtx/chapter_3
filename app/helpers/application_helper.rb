module ApplicationHelper
  def full_title(page_title = "")
    if page_title.empty?
      ""
    else
      page_title + " | "
    end
  end

end
