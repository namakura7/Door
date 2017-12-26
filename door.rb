require 'sqlite3'
require 'serialport'
require File.dirname(__FILE__) + '/log'


db = SQLite3::Database.new 'test.sqlite3'
key_number = 0
num = 1
nfc_port = "/dev/ttyUSB" + num.to_s
key_port = "/dev/ttyUSB" + key_number.to_s
baud = 9600
spw = SerialPort.new(key_port, baud)
file_name = "status.txt"
status = ""

puts "KEYPORT : " + key_port

loop do
	begin
		spr = SerialPort.new(nfc_port, baud)
		spr.read_timeout = 100
		
		puts "NFCPORT : " + nfc_port

		loop do
			begin
				tmp = ""
				loop do
					begin
						tmp += spr.readline
						if tmp.index("\n")
							break
						end
					rescue EOFError
						retry
					end
				end
				tmp = tmp.split(/\s*\n\s*/)
				max = 0
				nfc = ""

				tmp.each { |chr|
					if chr.size > max
						max = chr.size
						nfc = chr
					end
				}

				#puts "NFC : " + nfc

				if nfc != ""
					
					str = 'select * from users where nfc=\'' + nfc + '\''
					user = db.execute(str)

					if user.length > 0

						begin
							status = File.open(file_name).read.chomp
						rescue
							file = File.open(file_name, "w")
                            file.puts("OPEN ")
                            file.close
							retry
						end

						if status == "OPEN "
							str = '0'
							status = "CLOSE"
						else
							str = '1'
							status = "OPEN "
						end

						begin
							spw.write str
							file = File.open(file_name, "w")
                            file.puts(status)
                            file.close
						rescue
							puts "Error, cannot write key_port."
						end

						puts log(status, user[0][1])
						puts ""
					end

				end

			rescue => e
				puts e.message
				sleep(1)
				retry
			end
		end
	rescue
		if num >= 9
			num = 1
		elsif num == key_number
			num = num + 2
		else
			num = num + 1
		end

		nfc_port = '/dev/ttyUSB' + num.to_s
	end
end
