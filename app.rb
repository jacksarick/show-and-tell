require "socket"

PAGE_ROOT = "./pages/"

server = TCPServer.new('localhost', 3000)
print "server @ http://localhost:3000\n"

def compose(filename, replacements = nil)
	file = File.read(PAGE_ROOT + filename.strip)
	file = file.gsub(/<<<([^>]+)>>>/) {|include_file| compose($1)}

	if replacements != nil
		file = file.gsub(/\{\{\{([^\}]+)\}\}\}/) {|variable| replacements[variable]}
	end

	return file
end

def http_response(response)
	return "HTTP/1.1 200 OK\r\n" +
		"Content-Type: text/html\r\n" +
		"Content-Length: #{response.bytesize}\r\n" +
		"Connection: close\r\n" +
		"\r\n" +
		response
end

loop do

	socket = server.accept
	request = socket.gets.split

	print request
	print "\n"

	if request[0] == "GET"
		case request[1]
		when "/"
			socket.print http_response compose("index.html")
		else
			socket.print http_response "You asked for #{request[1]}"
		end
	else
		socket.print "Only GET requests are supported right now"
		socket.close
	end
end