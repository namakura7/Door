require "sqlite3"
require "serialport"


db = SQLite3::Database.new "test.sqlite3"
serial_port = "/dev/ttyUSB"
baud = 9600
nfc = String.new

for nfc_number in 0..9
	nfc_name = serial_port + nfc_number.to_s

	begin
		nfc_sp = SerialPort.new(nfc_name, baud)
		nfc_sp.read_timeout = 100
		nfc_sp.write "w"

		who = ""
		loop do
			begin
				who += nfc_sp.readline
				if who.index("\n")
					break
				end
			rescue EOFError
				retry
			end
		end
		who.chomp!

		if who == ""
			raise
		elsif who == "NFC"
			break
		end
	rescue Errno::ENOENT => e # No such file or directory
		if nfc_number >= 9
			puts "Can't find NFCPORT."
			exit
		end
	rescue
		sleep(1)
		retry
	end
end

puts "ユーザー名を入力してください。"
username = gets.chomp

puts "NFCをかざしてください。"
SerialPort.open(nfc_name, baud) do |sp|
	sp.read_timeout = 10
	loop do
		begin
			nfc += sp.readline
			if nfc.index("\n")
				break
			end
		rescue EOFError
			retry
		end
	end
end

tmp = nfc.split(/\s*\n\s*/)
max = 0
nfc = ""

tmp.each { |chr|
	if chr.size > max
		max = chr.size
		nfc = chr
	end
}
puts "NFC : \"#{nfc}\""

tag = db.execute("select * from users where nfc='#{nfc.split(/\s*\n\s*/)[0]}'")
if tag.length > 0
	puts "そのNFCタグはすでに使われています。"
	nfc = ""
end

if nfc != ""
	user = db.execute("select * from users where name='#{username}'")

	if user.length > 0
		str = "update users set nfc = \"#{nfc}\" where name = \"#{username}\";"
	else
		str = "insert into users (name, nfc) values ('#{username}', '#{nfc.split(/\s*\n\s*/)[0]}')"
	end
	db.execute(str)

	puts "登録完了しました。"

else
	puts "登録失敗しました。"

end

sleep(20)
