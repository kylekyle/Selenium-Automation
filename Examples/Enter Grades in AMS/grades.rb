require 'csv'
require 'watir'

Selenium::WebDriver::Chrome.path = "C:/Users/#{ENV['USER']}/AppData/Local/Chromium/Application/chrome.exe"

raise "Need a TSV with grades!" if ARGV.empty?	
puts "Navigate to your Grade Book to continue ...";

browser = Watir::Browser.new :chrome, :switches => %w[--log-level=3  --test-type]
browser.goto 'https://apps.usma.edu/ams/main.cfm'
browser.wait_until(timeout: 3600) { browser.title[/Grade Book/] }

columns = CSV.read(ARGV.first, headers: true, col_sep: "\t")

columns.by_col.each do |event,grades|
	left, right = browser.frames.to_a
	left.link(text: event).click
	right.link(text: /Edit/i).click
	fields = right.text_fields
	
	grades.each_with_index do |grade,i|
		fields[i].set grade
	end
	
	right.inputs(type:'submit').last.click
end

puts "Done"; sleep