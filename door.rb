require 'sqlite3'
require 'serialport'
require File.dirname(__FILE__) + '/log'


db = SQLite3::Database.new 'test.sqlite3'
baud = 9600
posix = "/dev/ttyUSB"
windows = "COM"
serial_port = posix

for key_number in 0..9
	key_name = serial_port + key_number.to_s

	begin
		key_sp = SerialPort.new(key_name, baud)
		sleep(0.5)
		who = key_sp.readline

		if who == ""
			raise
		elsif who != "KEY"
			if key_number == 9
				puts "Can't find KEYPORT."
				exit
			else
				next
			end
		else
			key_sp.read_timeout = 100
			break
		end
	rescue
		sleep(1)
		retry
	end
end

puts "KEYPORT : " + key_name

for nfc_number in 0..9
	if nfc_number == key_number
		next
	end

	nfc_name = serial_port + nfc_number.to_s

	begin
		nfc_sp = SerialPort.new(nfc_name, baud)
		sleep(0.5)
		who = nfc_sp.readline

		if who == ""
			raise
		elsif who != "NFC"
			if nfc_number == 9
				puts "Can't find NFCPORT."
				exit
			else
				next
			end
		else
			nfc_sp.read_timeout = 100
			break
		end
	rescue
		sleep(1)
		retry
	end
end

puts "NFCPORT : " + nfc_name

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
		nfc = ""

		tmp.each { |chr|
			if chr.size > max
				max = chr.size
				nfc = chr
			end
		}

		if nfc != ""
			
			begin
				sql = 'select * from users where nfc=\'' + nfc + '\''
				user = db.execute(sql)
			rescue
				sql = <<-SQL
				create table users (
					id integer primary key,
					name text,
					nfc text
				);
				SQL

				db.execute(sql)

				retry
			end


			if user.length > 0

				begin
					key_sp.write "0"
					sleep(0.5)
					status = key_sp.readline
					if status == ""
						raise
					end
				rescue => e
					puts e
					sleep(1)
					retry
				end

				begin
					key_sp.write "1"
				rescue
					puts "Error, cannot write " + key_name + "."
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
