# this script require the unidecoder and watir-webdriver gems, 
# and the WKHTMLTOPDF utility
require 'watir'
require 'unidecoder'

# so users don't have to install it
driver = File.join(Dir.pwd,"../../installation/chromedriver.exe")
Selenium::WebDriver::Chrome.driver_path = File.absolute_path(driver)

WKHTMLTOPDF = "C:\\Program Files\\wkhtmltopdf\\bin\\wkhtmltopdf.exe"

browser = Watir::Browser.new :chrome
browser.goto 'https://apps.usma.edu/ams/main.cfm'
browser.link(text: "I agree to the above. Continue into AMS").click

# for some reason there are two links, only one is visible
browser.links(text: "AIAD").find(&:visible?).click

browser.link(text:'Projects').click
browser.input(value:'Search').click

pdfs = File.join(Dir.pwd, 'PDFs')
links = browser.links.select {|link| link.href['ProjectDetails.aspx']}

links.each_with_index do |link,index|
	link.click
	
	# give the page a moment to load
	sleep 0.5
	
	browser.windows.last.use
	
	Dir.mktmpdir do |dir|	
		html = File.join(dir,"page.html")
		
		# save HTML
		# for some reason &nbsp; is replaced with \u00A0 on save :(
		File.write html, browser.html.to_ascii
		
		# Convert to PDF
		pdf = File.absolute_path(File.join(pdfs, "#{index}.pdf"))
		`"#{WKHTMLTOPDF}" "#{html.tr('/','\\')}" "#{pdf.tr('/','\\')}"`
	end
	
	browser.windows.last.close
	browser.windows.first.use
end

browser.close