function [days, hours, minutes, seconds] = TimeDivide(tSeconds)

	tSeconds = round(tSeconds);

	secsInDay = int32(86400);
	secsInHour = int32(3600);
	secsInMinute = int32(60);

	days = idivide(tSeconds, secsInDay);
	remainder = mod(tSeconds, secsInDay);

	hours = idivide(remainder, secsInHour);
	remainder = mod(remainder, secsInHour);

	minutes = idivide(remainder, secsInMinute)
	seconds = mod(remainder, secsInMinute);
end