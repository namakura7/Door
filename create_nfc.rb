require 'sqlite3'
require 'serialport'


db = SQLite3::Database.new 'test.sqlite3'
nfc_port = '/dev/ttyUSB0'
baud = 9600
nfc = String.new

puts 'ユーザー名を入力してください。'
username = gets.chomp

puts 'NFCをかざしてください。'
SerialPort.open(nfc_port, baud) do |sp|
	sp.read_timeout = 10
	loop do
		begin
			nfc += sp.readline
			if nfc.index('\n')
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
	puts 'そのNFCタグはすでに使われています。'
	nfc = ''
end

if nfc != ''
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

sleep(30)
