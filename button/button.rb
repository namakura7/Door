require "serialport"
require "#{File.dirname(__FILE__)}/../server"

baud = 9600
posix = "/dev/ttyUSB"
windows = "COM"

if RUBY_PLATFORM.downcase =~ /mswin(?!ce)|mingw|cygwin|bccwin/
	serial_port = windows
else
	serial_port = posix
end

btn_port = serial_port + "2" 


loop do
	begin
		tmp = ""
		loop do
			begin
				tmp += nfc_sp.readline
				if tmp.index("\n")
					break
				end
			rescue EOFError
				retry
			end
		end
		tmp.chomp!

		if tmp == ""
			raise
		elsif tmp == "PUSH"
			server()
		end

	rescue => e
		puts e.message
		sleep(1)
		retry
	end
end
