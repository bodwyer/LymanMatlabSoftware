function [] = PowerStripControl(dev, onoff)
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Controls power to each of the three ports on 
	% the programmable power strip. Used to turn on/off 
	% laser and APDs
	%
	% inputs
	%
	% * dev (str): device to turn on/off. can be one of 
	% LASER, APD1, APD2, ALL
	%
	% * onoff (str): turn selected channel on or off. Can be
	% either ON or OFF
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	% Determine which ports to send command to
	switch dev
	case 'LASER'
		portnum = '1';
	case 'APD1'
		portnum = '2';
	case 'APD2'
		portnum = '3';
	otherwise
		portnum = '#';
	end

	if strcmp(onoff, 'ON')
		state = '1';
	elseif strcmp(onoff, 'OFF')
		state = '2';
	else
		error('Improper command')
	end
		

	command = ['*0', portnum, state];

	% Get serial connection
	device = serial('COM1');

	% Set up connection parameters
	set(device, 'BaudRate', 300, 'DataBits', 8, ...
		'StopBits', 2, 'Parity', 'none');

	% Open connection
	fopen(device);

	% Send command
	fprintf(device, command);


	% Clean up
	fclose(device);
	delete(device);
	clear device

end

