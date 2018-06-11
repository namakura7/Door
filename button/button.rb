require "serialport"
require "#{File.dirname(__FILE__)}/server"

db = SQLite3::Database.new "test.sqlite3"
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
		tmp = tmp.split(/\s*\n\s*/)
		max = 0
		btn = ""

		tmp.each { |chr|
			if chr.size > max
				max = chr.size
				btn = chr
			end
		}

		if btn != ""

			server()

		end

	rescue => e
		puts e.message
		sleep(1)
		retry
	end
end
