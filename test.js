var str = "I have a Quiz on 10 Nov and im not prepared"
var par_date = "/(Quiz|Exam)+ +on+ +\d{1,2}\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)/i"
var check = par_date.test(str)
if (check) {
	var check2 = par_date.exec(str)
	var msg = check2[0].split(" ")
	var topic = msg[0]
	var time = msg.shift()
	var x = msg.join(" ")
	console.log(x)
};