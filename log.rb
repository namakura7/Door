require "date"

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

	wday =
		case date.wday
		when 0 then
			"Sun"
		when 1 then
			"Mon"
		when 2 then
			"Tue"
		when 3 then
			"Wed"
		when 4 then
			"Thu"
		when 5 then
			"Fri"
		else
			"Sat"
		end

	str = "#{date.strftime("%Y/%m/%d")}, #{wday}, #{change(time.hour)}:#{change(time.min)}:#{change(time.sec)} ## #{status} ## #{username}"

	File.open("log.txt", "a").puts(str)

	return str
end
