require 'csv'
require 'watir'

# so users don't have to install it
driver = File.join(Dir.pwd,"../../installation/chromedriver.exe")
Selenium::WebDriver::Chrome.driver_path = File.absolute_path(driver)

raise "Need a TSV with grades!" if ARGV.empty?	
puts "Navigate to your Grade Book to continue ...";

browser = Watir::Browser.new :chrome, :switches => %w[--log-level=3  --test-type]
browser.goto 'https://apps.usma.edu/ams/main.cfm'
browser.wait_until(timeout: 3600) { browser.title[/Grade Book/] }

# string encoding are the worst ...
file = File.read(ARGV.first).encode('ASCII',
  replace: '',
  undef: :replace,
  invlid: :replace 
)

rows = CSV.parse(file, headers: true)

# filter out columns that are obviously not events
headers = rows.headers.reject do |name|
  [/name/i, /total/i, /grade/i].any? {|re| name =~ re}
end

cnum, *events = headers
left = browser.frame(name: 'menu_win').wait_until_present

# Okay, AMS uses two frames: One for the menu on the left and 
# one for the content on the right. Every click reloads the 
# the frames, which invalidates the handles
events.each do |event|
  print "Entering grades for #{event} ... "
  
  left.link(text: event).wait_until_present.click
  right = browser.frame(name: 'crse_main_win')
  right.wait_until_present.link(text: /Edit/i).click
  
  browser.wait_until(timeout: 3600) do 
    right.wait_until_present
    right.trs.count > 10
  end
  
  tds = right.tds(visible_text: /\sC[0-9]{8}\s/)

  map = tds.each_with_object({}) do |td,hash|
    hash[td.text.strip] = td.parent.text_field
  end
  
  rows.each do |row|
    next unless row[event] and map[row[cnum]]
    map[row[cnum]].set row[event]
  end
  
  right.inputs(type:'submit').last.click
  puts "finished"
end

puts "Done"; sleep