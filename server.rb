require 'serialport'
require 'readline'
require File.dirname(__FILE__) + '/log'


baud = 9600
status = ""

(0..9).each { |num|
	key_port = '/dev/ttyUSB' + num.to_s

	begin
		key_sp = SerialPort.new(key_port, baud)

		begin
			key_sp.write "w"
			sleep(0.5)
			who = key_sp.readline.chomp
			puts "who : " + who

			if who == ""
				raise
			elsif who != "KEY"
				next
			end
		rescue => e
			sleep(1)
			retry
		end

		begin
			key_sp.write "0"
			sleep(0.5)
			status = key_sp.readline.chomp
			puts "status : " + status
			if status == ""
				raise
			end
		rescue => e
			sleep(1)
			retry
		end

		# 1.7秒のsleepが必要
		# sleep(1.7)
		key_sp.write "1"
		key_sp.close

		break
	rescue
		next
	end
}

if status == ""
	puts "Can't change status."
else
	log(status, "SERVER")
end
