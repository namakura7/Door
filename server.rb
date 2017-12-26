require 'serialport'
require 'readline'
require File.dirname(__FILE__) + '/log'


def serial_port_name num
	return '/dev/ttyUSB' + num.to_s
end


# 周波数
baud = 9600
file_name = "status.txt"

begin
	status = File.open(file_name).read.chomp
rescue
	File.open(file_name, "w").puts("OPEN ")
	retry
end

if status == "OPEN "
	str = '0'
	status = "CLOSE"
else
	str = '1'
	status = "OPEN "
end

(0..9).each { |num|
	key_port = serial_port_name(num)

	begin
		sp = SerialPort.new(key_port, baud)
		# 1.7秒のsleepが必要
		sleep(1.7)
		sp.write str
		sp.close
		break
	rescue
		next
	end
}

file = File.open(file_name, "w")
file.puts(status)
file.close

log(status, "SERVER")
