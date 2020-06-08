# Instructions:
# Instructions were saved as png-Files in the folder Stimuli/Instruktion/
# Subject can switch forward and backward through the instruction slides
# There is an example experiment after the instruction trial

default_background_color = 125, 125, 125;
default_text_color = 0, 0, 0;
default_text_align = align_center;
default_font = "Arial";
default_font_size = 0.8; # with definition of screen parameters, font size is relative to user defined units

screen_width_distance = 40; 
screen_height_distance = 11;
max_y = 5.5;

active_buttons = 3;   
button_codes = 1,2,3;
default_all_responses = true;

response_logging = log_all;
response_matching = simple_matching;

begin;

#instruction files
array {
	LOOP $pic_nr '2';
		$pic = '$pic_nr + 1';
		bitmap { filename = "Folie$pic.png"; 
				preload = true; 
				width = 39;
				scale_factor = scale_to_width;
				};
	ENDLOOP;
} instr_array;

#demo files
array {
	text { caption = "Regulieren"; description = "1";} reg;
	text { caption = "Betrachten"; description = "2";} bet;
} demo_instr_array;

array {
LOOP $pic_nr '2';
	$pic = '$pic_nr + 1';
	bitmap { filename = "example$pic.jpg"; 
				preload = true; 
				width = 28;
				scale_factor = scale_to_width;
				};
ENDLOOP;
} pics;

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

text { caption = "+"; description = "5"; } plus;
text { caption = "Wie fühlen Sie sich jetzt?"; } rating_text;

picture { text plus; x=0; y=0; } fixcross;

#rating files
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

#instruction trial
trial {                                  
    trial_type = first_response;     
		picture { bitmap { filename = "Folie1.png";
									preload = true;
									}; x=0; y=0; } instr_folie;
		time = 0;
		duration = response;
} instr_trial; 

# blank trial
trial {
	stimulus_event {
		picture { text { caption = "+"; font_color = 125,125,125;}; x = 0; y = 0; };
		code = "blank";
		duration = 2000;
	} blank_event;
} blank_trial;

# main trial
trial {
	stimulus_event {
		picture fixcross;
		code = "fixcross";
		duration = 2000;
		}fixcross_event;
	stimulus_event {
		picture { text bet; x = 0; y = 0; 
					} instr_pic;
		deltat = 2000;
		duration = 2000;
		} instr_event;
	stimulus_event {
      picture { bitmap { filename = "example1.jpg"; 
								 preload = true;
								}; x = 0; y = 0; 
					 bitmap view_bmp; x = -17; y = 0; 
					 bitmap view_bmp; x = 17; y = 0;
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

begin_pcl;

#instruction slides
int slide_nr=1;
int nr_of_instructionslides=2;
int goforwardorbackward;

loop until slide_nr>nr_of_instructionslides begin
	
	instr_folie.set_part(1,instr_array[slide_nr]);
	
	goforwardorbackward=0;
	
	instr_trial.present();
	if response_manager.last_response()==1 then
		goforwardorbackward=-1;
	elseif response_manager.last_response()==2 then
		goforwardorbackward=1;
	end;
	
	if (slide_nr==1 && goforwardorbackward==-1) || slide_nr>nr_of_instructionslides then
	else
		slide_nr=slide_nr+goforwardorbackward;
	end;
	
end;

#task demo

bool ratevalence = true; # false: only arousal rating
int rating_duration = 7000;

array <int> rating_out[2];
int response_counter;
stimulus_data trial_onset;
stimulus_data trial_offset;

#rating subroutine
sub array <int,1> rating_sub (bitmap dimension) begin
	response_counter = response_manager.response_data_count();
	int exit_response = 0;
	int end_time = clock.time()+rating_duration;
	rating_pic.set_part(2,dimension);
	array <int> rating_val[9]= {1,2,3,4,5,6,7,8,9};
	rating_val.shuffle(1,9);
	int value = rating_val[1];
	loop int l=1 until clock.time()>=end_time || exit_response==1 begin
		bitmap rating_bmp=rating[value];
		rating_pic.set_part(3,rating_bmp);
		rating_trial.set_duration(end_time-clock.time());
		rating_trial.present();
		
		rating_event.set_event_code("refresh_scale");
		if response_manager.last_response() == 1 && value>1 then 
			value=value-1;
		elseif response_manager.last_response() == 2 && value<9 then 
			value=value+1;
		elseif response_manager.last_response() == 3 then 
			exit_response = 1;
		end;
		
		if response_manager.response_data_count() > response_counter then
			term.print("\nbutton press: "+response_manager.last_response_label());
			response_counter = response_manager.response_data_count();
		end;	
		
		l=l+1;
	end;	
	wait_until(end_time);
	array <int> out [2];
	out[1] = value;
	out[2] = exit_response;
	return out; 
end;

#demo experiment

loop int m = 1 until m>2 begin
	er_trial.present();
	blank_trial.present();
	trial_offset = stimulus_manager.last_stimulus_data();
	trial_onset = stimulus_manager.get_stimulus_data(stimulus_manager.stimulus_count()-2);
	rating_trial.set_start_time(trial_offset.time()+2000);

	rating_event.set_event_code("rating_arousal");
	rating_out = rating_sub(sam_arousal);
	term.print("\narousal rated "+string(rating_out[1]));
	
	if ratevalence then
		rating_event.set_event_code("rating_valence");
		rating_out = rating_sub(sam_valence);
		term.print("\nvalence rated "+string(rating_out[1]));
	end;
	
	instr_pic.set_part (1,reg);
	er_pic.set_part(1, pics [2]);
	er_pic.set_part(2,regulate_bmp);
	er_pic.set_part(3,regulate_bmp);
	
	m = m+1;
end;

