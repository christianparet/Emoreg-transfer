pcl_file = "Emoreg_transfer_20200608.pcl";

default_background_color = 125, 125, 125;
default_text_color = 0, 0, 0;
default_text_align = align_center;
default_font = "Arial";
default_font_size = 0.8; # with definition of screen parameters, font size is relative to user defined units

screen_width_distance = 40; 
screen_height_distance = 11;
max_y = 5.5;

#rating
active_buttons = 3;   
button_codes = 1,2,3;
default_all_responses = true;

#scenario_type = fMRI_emulation;
scenario_type = fMRI;
pulse_code = 23;
pulses_per_scan = 1;
scan_period=2000;

response_logging = log_all;
response_matching = simple_matching;

write_codes = false;
# write_codes = true;
# response_port_output = false;

begin;

###########################################
###             Stimulation             ###
###########################################

$nr_pics = 30 ; 

array {
LOOP $pic_nr '$nr_pics';
	$pic = '$pic_nr + 31';
	bitmap { filename = "pics\\pic$pic.jpg"; 
				preload = true; 
				width = 28;
				scale_factor = scale_to_width;
				};
ENDLOOP;
} pics;

array {
LOOP $value_nr 9;
	$value = '$value_nr + 1';
	bitmap { filename = "rating\\rating$value.png"; 
				preload = true; 
				width = 28;
				scale_factor = scale_to_width;
				};
ENDLOOP;
} rating;

text { caption = "+"; description = "5"; } plus;
text { caption = "Wie fühlen Sie sich jetzt?"; } rating_text;

picture { text plus; x=0; y=0; } fixcross;
#picture { bitmap { filename = "ende_run.jpg";} ende_run_bmp; x=0;y=0;} ende;

array {
	bitmap { filename = "regulate.png"; 
				alpha = -1; 
				preload = true;
				width = 5;
				scale_factor = scale_to_width;
				} regulate_bmp;
	bitmap { filename = "view.png"; 
				alpha = -1; 
				preload = true;
				width = 5;
				scale_factor = scale_to_width;
				} view_bmp;
	bitmap view_bmp;
} cond_bmp_array;

array {
	text { caption = "Regulieren"; preload = true;};
	text { caption = "Betrachten"; preload = true;};
	text { caption = "Betrachten"; preload = true;};
} instr_array;

bitmap { filename = "rating\\Sam_arousal.png"; 
			preload = true; 
			width = 28;
			scale_factor = scale_to_width;
			} sam_arousal;

bitmap { filename = "rating\\Sam_valence.png"; 
			preload = true; 
			width = 28;
			scale_factor = scale_to_width;
			} sam_valence;

#Instruction
trial {
	trial_type = fixed;
	picture { text { caption = "Gleich geht's los"; description = "prepare";}; x = 0; y = 0; };
	code = "prepare";
	duration = next_picture;
} instruction_trial;

# blank trial
trial {
	stimulus_event {
		picture { text { caption = "+"; font_color = 125,125,125;}; x = 0; y = 0; };
		code = "blank";
	} blank_event;
} blank_trial;

# main trial
trial {
	stimulus_event {
		picture fixcross;
		code = "fixcross";
		}fixcross_event;
	stimulus_event {
		picture { text plus; x = 0; y = 0; 
					} instr_pic;
		deltat = 2000;
		} instr_event;
	stimulus_event {
      picture { bitmap { filename = "pics\\pic1.jpg"; 
								 preload = true;
								}; x = 0; y = 0; 
					 bitmap regulate_bmp; x = -17; y = 0; 
					 bitmap regulate_bmp; x = 17; y = 0;
					} er_pic;
		code = "pic_onset";
		deltat = 2000;
		duration = 12000;
		} er_event;
} er_trial;

# rating trial
trial {
	trial_type = first_response;
	stimulus_event {
		picture { text rating_text; x=0; y=2; 
					 bitmap sam_arousal; x=0; y=-0.5; 
					 bitmap {filename = "rating\\rating1.png";
								preload = true;
								width = 28;
								scale_factor = scale_to_width;
								}; x=0; y=-2.5; 
					} rating_pic;     
	} rating_event;
} rating_trial;

# ende
trial {
	trial_duration = 2000;
	trial_type = fixed;    	
	picture { text { caption = "Ende"; description = "end";}; x = 0; y = 0; };
	code = "end"; 
} end_trial; 