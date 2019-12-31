Pod::Spec.new do |s|

s.name         = "DDOCScrollPageView"
s.version      = "0.0.1"
s.summary      = "DDOCScrollPageView 分页滚动视图，实现tableview嵌套滚动效果，用于替代UIPageViewController"
s.homepage     = "https://github.com/BrownCN023/DDOCScrollPageView"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author       = { "liyebiao1990" => "347991555@qq.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/BrownCN023/DDOCScrollPageView.git", :tag => s.version }
s.source_files = "DDOCScrollPageView/**/*.{h,m}"
s.requires_arc = true
s.frameworks = "Foundation","UIKit"

s.dependency "Masonry", "~> 1.1.0"

end
