require 'serialport'

def func(str)
	key_port = '/dev/ttyUSB0'
	baud = 9600

	begin
		sp = SerialPort.new(key_port, baud)
		sp.write(str)
		sp.close
	rescue
		#sleep(1)
		#retry
	end

	hoge = if str == "o"
						"OPEN"
				 else
						"CLOSE"
				 end

	t = Time.new
	puts t.strftime("%Y-%m-%d %H:%M:%S") + " : " + hoge
end

text = "tmp.txt"

before_connected = 0
before_disconnected = 0
before_ap = ""


loop do
	ap = ""

	File.open(text, "r") do |txt|
		ap = txt.read
	end

	if ap != before_ap
		before_ap = ap

		connected = ap.scan(/AP-STA-CONNECTED/).size
		disconnected = ap.scan(/AP-STA-DISCONNECTED/).size

		if before_connected != connected || before_disconnected != disconnected

			if connected > disconnected
				# OPEN
				func("o")
			else
				# CLOSE
				func("c")
			end

			before_connected = connected
			before_disconnected = disconnected

		end
	end

	sleep(1)
end
