require 'csv' 
require 'watir'

Selenium::WebDriver::Chrome.path = "C:/Users/#{ENV['USER']}/AppData/Local/Chromium/Application/chrome.exe"

browser = Watir::Browser.new :chrome, :switches => %w[--log-level=3 --test-type]
browser.goto 'https://apps.usma.edu/ams/main.cfm'
browser.link(text: "I agree to the above. Continue into AMS").click

# for some reason there are two browser links, only one is visible
whois = browser.links(text: "WHOIS").find(&:visible?)

if whois
	whois.click
else
	raise "You don't have the WHOIS AMS app!"
end

# rost should be in the format "last_name\tfirstname"
roster = CSV.read "roster.tsv", col_sep: "\t"

fields = [
	'Name', 
	'Sex', 
	'Primary Duty', 
	'Major', 
	'2nd Maj',
	'CQPA',
	'Basic Branch', 
	'USMA ID', 
	'Class', 
	'Phone',
	'Eligible for Travel?'
]

CSV.open("results.csv", "w") do |csv|
	csv << fields

	roster.each do |last,first|
		browser.text_field.set last
		browser.input(type:'submit').click
		
		row = browser.td(text: /#{last}, #{first}/i).parent
		
		if row.exists?
			row.link.click
			browser.window(title: /#{last}, #{first}/i).wait_until_present
			browser.window(title: /#{last}, #{first}/i).use
			
			result = fields.reduce({}) do |hash,field|
				td = browser.td text: field
				hash[field] = td.exists? ? td.next_sibling.text : nil
				hash
			end
			
			result['Sex'] = result['Sex'][0]
			result['Eligible for Travel?'] = browser.text[/Not Eligible For Travel/] ? 'NO' : 'YES'
			
			p result # give the user come feedback on the CLI
			
			csv << result.values
			browser.windows.first.use
		else
			csv << ["Could not find #{first} #{last}"]
		end
	end
end

browser.close