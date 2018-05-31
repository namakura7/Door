require 'date'

def change(num)
	if num < 10
		return "0#{num.to_s}"
	else
		return num.to_s
	end
end

def log(status, username)
	date = Date.today
	time = DateTime.now

	str = "#{date.strftime("%Y/%m/%d")}, #{change(time.hour)}:#{change(time.min)}:#{change(time.sec)} ## #{status} ## #{username}"

	File.open("log.txt", "a").puts(str)

	return str
end
