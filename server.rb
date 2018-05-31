require 'serialport'
require 'readline'
require File.dirname(__FILE__) + '/log'


baud = 9600
status = ""

(0..9).each { |num|
	key_port = "/dev/ttyUSB#{num.to_s}"

	begin
		key_sp = SerialPort.new(key_port, baud)
		key_sp.read_timeout = 100
		key_sp.write "w"

		who = ""
		loop do
			begin
				who += key_sp.readline
				if who.index("\n")
					break
				end
			rescue EOFError
				retry
			end
		end
		who.chomp!

		if who != "KEY"
			next
		end

		key_sp.write "0"

		loop do
			begin
				status += key_sp.readline
				if status.index("\n")
					break
				end
			rescue EOFError
				retry
			end
		end
		status.chomp!

		if status == ""
			puts "Can't change status."
			exit
		else
			log(status, "SERVER")
		end

		# 1.7秒のsleepが必要
		sleep(1.7)
		key_sp.write "1"
		key_sp.close

		break
	rescue
		next
	end
}
