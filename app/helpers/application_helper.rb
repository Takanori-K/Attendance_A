module ApplicationHelper
  
  # ページごとにタイトルを返す。
  def full_title(page_title = "")
    base_title = "勤怠管理システム"
    if page_title.empty? #empty?: 文字列と配列の中身が空
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
