#require 'json'
require 'date'
require 'nokogiri'

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
	
	nn = '192.168.1.0/24'
	nmap ='nmap -n -sP -oX - ' + nn
	scan = `#{nmap}`
	
	doc = Nokogiri::XML.parse(scan)
	#doc = Nokogiri::XML(File.open("sample.xml"))

	net = []
	doc.css('host').each do |h|
		ip = "xxx.xxx.x.xx"
		hw = "xx:xx:xx:xx:xx:xx"
		status = "x"
		hostname = "unk"
		vendor = "unk"
		h.css('address').each do |a|
			#puts a['addrtype']
			if a['addrtype'] == 'ipv4'
				ip = a['addr']
				# can only do name resolving on Linux
				#cmd ='avahi-resolve-address ' + ip 
				#hs = `#{cmd}`
				#hostname = hs.split(' ')[1]
				
				# need to save screen room
				ip = ip.split('.')[3]
			elsif a['addrtype'] == 'mac'
				hw = a['addr']
				vendor = a['vendor']
			end
		end
	
		h.css('status').each do |s|
			stat = s['state']
			if stat == 'up'
				status = 'fa fa-thumbs-o-up'
			elsif stat == 'down'
				status = 'fa fa-thumbs-o-up'
			else
				status = 'fa fa-warning'
			end
		end
	
		h.css('hostnames').each do |n|
			hostname = n.text
			if hostname == "\n"
				hostname = 'unk'
			end
		end
	
		net.push({hw: hw, ip: ip, status: status, hostname: hostname, vendor: vendor })
	end
	
	time = Time.new
	t = time.strftime "%l:%M %p"
	send_event('netscan', { :updateTime => t, :network => net, :networkname => nn})
	
end