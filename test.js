var str = "Quiz on 10 Nov"
var par_date = /(Quiz|Exam)+ +on+ +\d{1,2}\s+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\s/i
var check = pat.test(str)
var check2 = par_date.test(str)
if (check) {
	console.log('Quiz Found\n')
};
if (check) {
	console.log('Date Found\n')
};