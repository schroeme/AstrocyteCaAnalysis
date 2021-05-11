function s= spike_detect_mah_v1_Alexeditsv2_MESastros(folderpath,analysis,neurons)

% Additional functions/structures needed
   % Add_Event_Lines
   % spikes_matt.mat
   
% analsysis structure
    %analysis.F_cell_scaled    -- fluorescence signal (scaled however)
    %analysis.fps  -- framerate
    
    
% spikes_struct -- structure containing example spikes      
    spikes_struct=load([pwd filesep 'spikes_matt.mat']); %!!!!!!!!
%% Convert variable from analysis structure to my names

fps=analysis.fps;
%Exp_Folder=analysis.filename;    
Exp_Folder=folderpath;

Fo=analysis.F_bkg(1,:)';
F=analysis.F_cell(neurons,:)';
% F=analysis.F_cell_scaled;



%% Estimage Background Noise

BG_mod=fit([1:size(Fo,1)]',mean(Fo,2),'linearinterp');
coefs=mean(BG_mod.p.coefs);

BG_linfit=(1:size(Fo,1)).*coefs(1)+coefs(2);

BG=BG_linfit';

[b,a]=butter(15,1/10,'high');
BG_noise=5*std(filtfilt(b,a,mean(Fo,2)))/mean(BG);


%% Begin Spike Detection

hh=waitbar(0,'Analyzing Spikes');
spks=cell(size(F,2),1);
baseline=spks;
amplitudes=spks;
baseline_locs=spks;
peak_locs=spks;
scrsz = get(0,'ScreenSize');
gg=figure('Position',[10 scrsz(3)/3 scrsz(3)/1.1 scrsz(4)/3]);

for xx=1:size(F,2)
    waitbar(xx/size(F,2),hh,{'Analyzing Spikes:' ; Exp_Folder});
    set(hh,'Position',[10 700 500 60])
    try
       %%%% Spike Detection Algorithm BEGIN
        
       %%%% Default values
%             xx=1;  %run from here until catch to examine single neuron
            x=F(:,xx)./BG;
            
            % Estimate SNR of signal
            
%             snr_win=[5 10 15 20 25 30];
            snr_win=[5:25:200 500 1000 2000];
            x_std_cell=cell(length(snr_win),1);
            for yy_tmp=1:length(snr_win) %loop through each SNR window
                x_std_cell{yy_tmp}=zeros(size(x,1)-snr_win(yy_tmp),1);
                for xx_tmp=1:size(x_std_cell{yy_tmp},1);  %loop through each frame in that window
                    x_std_cell{yy_tmp}(xx_tmp)=std(x(xx_tmp:(xx_tmp+snr_win(yy_tmp)))); 
                end
                SNR_tmp(yy_tmp)=prctile(x_std_cell{yy_tmp},99)./prctile(x_std_cell{yy_tmp},1);
            end
            
            SNR=std(SNR_tmp);
            
            spikes=spikes_struct.spikes;
            
            % Look closer at these  values
            if SNR<2.5
                thr=.55;
            else
                thr=.65;
            end
            
            %thr=.65;
%             fps=20;
            height=BG_noise;
            %%% Default Values

            % Save a copy of raw signal
            xorig = x; 

            % Preallocate memory for variables
            spks_tmp2 = [];
            Call = nan(length(spikes),length(x));

            %% Start Event Detection     
%             if (abs(moment(x,3))>=.0000001)  || SNR>2.5  %%change to 3 - set lower for working through signals
              if SNR>1.5 %.5  %2.5  %%change to 3 - set lower for working through signals

                % Run initial event detection
                for i=1:length(spikes)
                    snippet = spikes{i};  % example waveform
                    L = length(snippet);  % length of example waveform
                    C = zeros(size(x));   % Correlation values
                    x_snippet_matrix=nan(L,length(x)-(L+1));
                    for j=1:length(x)-(L+1)  % run snippet along length of Ca signal and calculte correlation at each point
                       x_snippet = x(j:j+L-1);
                       x_snippet_matrix(1:L,j)=x_snippet;
                       clear x_snippet
                    end
                       
                        R = corr(x_snippet_matrix,snippet');
                        highsignalindices=find(range(x_snippet_matrix,1)>height);
                        C(highsignalindices)=R(highsignalindices);
                        Call(i,:) = C;
                        
                        %clear x_snippet_matrix
                end
                
%                 for i=1:length(spikes)
%                     snippet = spikes{i};  % example waveform
%                     L = length(snippet);  % length of example waveform
%                     C = zeros(size(x));   % Correlation values
%                     for j=1:length(x)-(L+1)  % run snippet along length of Ca signal and calculte correlation at each point
%                         x_snippet = x(j:j+L-1);
%                         if(range(x_snippet)>height) % only calculate correlation if the magnitude of the x_snippet is high enough
%                             R = corrcoef(x_snippet,snippet);
%                             C(j) = R(1,2);
%                         end
%                     end
%                     Call(i,:) = C;
% 
%                 end

 %%%%%          % Condense Call matrix into trace of likelihood of peak occurring
                Call=medfilt2(Call,[1 5]);
                
                Call_parts=zeros(7,size(Call,2));
                Call_parts_low=zeros(7,size(Call,2));
                for ee=1:7
                    Call_parts(ee,:)=sum(Call(((ee-1)*12+1):((ee-1)*12+12),:)>thr)./...
                        sum(~isnan(Call(((ee-1)*12+1):((ee-1)*12+12),:)),1);
                    
                    Call_parts_low(ee,:)=sum(Call(((ee-1)*12+1):((ee-1)*12+12),:)<-thr)./...
                        sum(~isnan(Call(((ee-1)*12+1):((ee-1)*12+12),:)),1);
                    
                    
                    Call_parts(ee,isnan(Call_parts(ee,:)))=0;
                    Call_parts_low(ee,isnan(Call_parts_low(ee,:)))=0;
                    
                   Call_parts(ee,:)=filtfilt(ones(fps/4,1)./(fps/4),1,medfilt1(Call_parts(ee,:),3));
                   Call_parts_low(ee,:)=filtfilt(ones(fps/4,1)./(fps/4),1,medfilt1(Call_parts_low(ee,:),3));                    
                end
                
                spks_tmp_main=sum(Call_parts)./7;
                spks_tmp_low=sum(Call_parts_low)./7;
                
                    
                
                %% sort type of signal to determine pk detection threshold  
                    [pks_main,locs_main]=findpeaks(spks_tmp_main,'MINPEAKHEIGHT',.001,'MINPEAKDISTANCE',fps/5); %run initial pk detection to get values for sorting
                     meanpk = mean(pks_main); %avaerage correlation pk values
                     maxpk = max(pks_main);   %max correlation pk value

                    if SNR<2.5 %<3 % NEED TO FIND MAX THIS # SHOULD BE ?? %If very noisy
                       if  .8 < maxpk./meanpk && maxpk./meanpk< 1.2 %if all pks about the same height
                          peak_thr =.25*maxpk; % set threshold proportional to max pk value
                          
                       elseif maxpk/meanpk>2 % if big difference between max pk and average of pks
                               peak_thr=.45*maxpk;  % set larger threshold, so little noisy pks not detected
                               
                       else % or if ther area a range of little noisy pks
                            peak_thr=.03; % set tiny threshold
                            
                       end
                    else %if not very noisy, set large threshold
                       peak_thr=.35*maxpk;  % proportional to max pk value
                    end
                    peak_thr;
                    
                    peak_thr_low=.001;
                    
                    peak_distance = fps/5; 

                % old simpler sorting method
                % if mean(spks_tmp_main) > .32 %high amplitudes (larger correlations)
                %     peak_distance = fps/5;    %lower pks tend to be noise, so ignore these
                %     peak_thr=.2;
                % else    %low pks mean low correlations and noisy signals; small pks are important
                %     peak_distance = fps/5; %further distm because more incorrect pk detection with noisy signals
                %     peak_thr=.01;
                % end
                
                
                %% Find initial guesses for spikes (identified at beginning points of
                % transient)

                [pks_main,locs_main]=findpeaks(spks_tmp_main,'MINPEAKHEIGHT',peak_thr,'MINPEAKDISTANCE',peak_distance);
                [pks_low,locs_low]=findpeaks(spks_tmp_low,'MINPEAKHEIGHT',peak_thr_low,'MINPEAKDISTANCE',peak_distance);

                smoothed_low = filtfilt(ones(3,1)./3,1,spks_tmp_low);
                smoothed_main = filtfilt(ones(3,1)./3,1,spks_tmp_main); 
                [pks_low,locs_low]=findpeaks(smoothed_low,'MINPEAKHEIGHT',peak_thr_low,'MINPEAKDISTANCE',peak_distance);
                %[pks_main,locs_main]=findpeaks(smoothed_main,'MINPEAKHEIGHT',.01,'MINPEAKDISTANCE',peak_distance);

                %variance btwn pks (for sorting)
                u=zeros(size(locs_main)-1);
                y=zeros(size(locs_main));
                for mm=1:size(locs_main,2)-1
                    u(mm) = (locs_main(mm+1)-locs_main(mm));
                end
                y = std(u,0,2);

        %% Delete Extra Peaks -- these are short checks that look for common errors in peak detection
             % line 188 through 
             
        % Run through main peaks and check if there is a low peak close enough
%                 pks_delete_index=zeros(size(locs_main));
%                 for pp=1:size(locs_main,2)
%                %  if pks_main(pp)<.1 %&& max(pks_main)>.6
%                  dist_thrsh = fps*5; %=50  work with this #; higher # may give extra pks  
%                     if  sum((locs_low-locs_main(pp))< dist_thrsh & (locs_low-locs_main(pp))>0)==0  %if these 2 peaks are closer than ## units
%                         pks_delete_index(pp)=1;
%                %    end 
%                  end
%                 end
%                 locs_main(find(pks_delete_index))=[]; % delete all slots with 1
%                 pks_main(find(pks_delete_index))=[];            
                
           % Deletes extra peaks by keeping only one pk followed by a low pk
                %Looks at peaks ahead
                pks_delete_index=zeros(size(locs_main));
                for pp = 1:size(locs_main,2)-1 
                     %if pks_main(pp)<.2 %&& max(pks_main)>.6
                     pot_match=locs_low-locs_main(pp);
                     pot_match(pot_match<0)=[];
                     
                     if ~isempty(pot_match)
                         pot_seq_peak=locs_main-locs_main(pp);
                         pot_seq_peak=(find(pot_seq_peak>0 & pot_seq_peak < min(pot_match)  & pot_seq_peak < fps/2));

                         if ~isempty(pot_seq_peak)
                             if (abs(locs_main(pp)-locs_main(pp+1)) < min(pot_match)) ...
                                    && (pks_main(pp)-pks_main(pot_seq_peak(1))) < 0 % if the pk ahead is smaller, don't delete
                                        pks_delete_index(pp)=1;
                             end
                         else
                              if (abs(locs_main(pp)-locs_main(pp+1)) < min(pot_match))
                                  pks_delete_index(pp)=1;
                              end
                         end
                     else
                          pks_delete_index(pp)=1;
                     end

                end
                locs_main(find(pks_delete_index))=[]; % delete all slots with 1
                pks_main(find(pks_delete_index))=[];    
                
                %looks at peaks behind
                pks_delete_index=zeros(size(locs_main));
                for pp = 2:size(locs_main,2) %adjust for edge pks
                   % if pks_main(pp)<.2 %&& max(pks_main)>.6
                    if (locs_main(pp)-locs_main(pp-1) < min(abs(locs_low-locs_main(pp))))...
                            && (pks_main(pp)-pks_main(pp-1)) < 0 % if the pk behind is smaller, don't delete
                  pks_delete_index(pp)=1;
                  %  end  
                     end
                end
                locs_main(find(pks_delete_index))=[]; % delete all slots with 1
                pks_main(find(pks_delete_index))=[]; 
                
            %Delete extra pks by ensuring main, low, main pattern
                if size(locs_main,2)>1  %only run if more than one peak detected
                pks_delete_index=ones(size(locs_main));
                for pp=1:size(locs_main,2)-1
                    if pks_main(pp) > .8*maxpk  % if prominent pk
                        pks_delete_index(pp)=0; %don't delete
                    end
                    pks_delete_index(size(locs_main,2)) = 0;
                    pp_range = locs_main(pp):locs_main(pp+1); % create matrix of locations from one main pk to next
                     for tt = 1:size(locs_low,2)   
                      for uu = 1:size(pp_range,2) 
                       if pp_range(uu)==locs_low(tt) % if there is a low pk in the range between main pks
                           pks_delete_index(pp)=0;   % don't delete
                       end
                      end
                    end
                end
                locs_main(find(pks_delete_index))=[]; % delete all slots with 1
                pks_main(find(pks_delete_index))=[]; 
                end
                
              

           %less homogenic signals use smoothed function
           %[pks_main,locs_main]=findpeaks(smoothed_main,'MINPEAKHEIGHT',.005,'MINPEAKDISTANCE',peak_distance);

                
%                if (locs_main(pp)-locs_main(pp-1) < min(abs(locs_low-locs_main(pp))))||(abs(locs_main(pp)-locs_main(pp+1)) < min(abs(locs_low-locs_main(pp))))
%                aa = find(diff(pks_delete_index)==1);
%                bb = find(diff(pks_delete_index)==-1);
%                uu =[];
%                for ff = 1:length(aa)
%                     range_tmp = (aa(ff)+1):bb(ff);
%                     uu=[uu;range_tmp'];
%                     npl(ff) = range_tmp(find(max(pks_main((aa(ff)+1):bb(ff)))==max(pks_main((aa(ff)+1):bb(ff)))))
%                     uu(uu==npl(ff))=[];
%                end  
%                
%                 locs_main(uu)=[]; % delete all slots with 1
%                 pks_main(uu)=[];      
                

                %% Revised Peak detection on filtered event detection signal
                % Find peak of spikes by walking along gradient and finding first max
                grad_spks=medfilt1(gradient(x),3);
                search_dist=fps*2;
                offset=5;
                locs_peak = locs_main;
                locs_left=locs_main;
                

                locs_peak=nan(size(locs_left));
                locs_right=locs_left;
                for zz=1:size(locs_left,2)
                    search_range_right=(locs_left(zz)+offset):min([size(grad_spks,1) locs_left(zz)+search_dist]);        
                    peak_zero=search_range_right(find(grad_spks(search_range_right)<=-.001,1,'first'));
                    locs_peak(zz)=peak_zero;      
                end

                % Revise pks and left locs locations by looking in immediate region
                s_range=1;
                for pp=1:size(locs_peak,2)
                   new_peak=max(x(locs_peak(pp)-s_range:locs_peak(pp)+s_range));
                   locs_peak(pp)=locs_peak(pp)-s_range-1+find(x(locs_peak(pp)-s_range:locs_peak(pp)+s_range)==new_peak,1,'first');

                   new_left=prctile(x(locs_left(pp)-s_range:locs_peak(pp)),50);
                   locs_left(pp)=locs_left(pp)-s_range-1+find(x(locs_left(pp)-s_range:locs_left(pp)+s_range)<=new_left,1,'last');

                end
                amplitudes_tmp=x(locs_peak)-x(locs_left);
                baseline_tmp=x(locs_left);
                spks_tmp2=locs_left;


                %%%% Spike Detection Algorithm END
                
                
                
                % Remove spikes whose amplitudes are less than noise
                %LOOK INTO IMPLEMENITING THESE; USEFUL FOR REMOVING SPIKES
                %ON DOWNSTROKE; BUT SHOULD BE A BETTER WAY TO REMOVE THOSE
%                 spks_tmp2(amplitudes_tmp<1.5*height)=[];
%                 amplitudes_tmp(amplitudes_tmp<1.5*height)=[];
%                  spks_tmp2(amplitudes_tmp<height)=[];
%                  amplitudes_tmp(amplitudes_tmp<height)=[];
                % figure
                % imagesc(Call);
                
                
                
                %% Plot spike detection in real time for visual inspection
                
                subplot(2,1,1)
%                 OverlaySpikes(xorig,spks_tmp2);
                
                plot(xorig,'k'); ylim([min([.95 prctile(xorig,.1)]) max([prctile(xorig,100)+.1 1.1])]);
                Add_Event_Lines(gca,spks_tmp2);
                

                spks{xx}=spks_tmp2;
                amplitudes{xx}=amplitudes_tmp;
                baseline{xx}=baseline_tmp;
                baseline_locs{xx}=locs_left;
                peak_locs{xx}=locs_peak;

                hold on;
                title([num2str(xx) ': SNR = ' num2str(SNR)]);    %pause(.5);
                plot(locs_peak,x(locs_peak),'ro')
                hold off;

                subplot(2,1,2)

                plot(spks_tmp_main)
                hold on
                plot(smoothed_low, 'r')
                plot(locs_main,pks_main, 'o')
                plot(locs_low,pks_low, 'ro')
                hold off

                pause(.01)
                
            else
                plot(xorig,'r');
                disp(['Skipped ' num2str(xx) ' due to low SNR']);
             end       
    catch
        spks{xx}=[];
        disp({['SpikeLib failed for: ' Exp_Folder '\'];...
            ['At node: ' num2str(xx)]})
        pause(.01)
    end
end
 close(hh);
close(gg);

% Convert cell spks to raster
rstr=zeros(size(F,1),size(spks,1));
for xx=1:size(rstr,2)
    rstr(spks{xx},xx)=1;
end

% 
% figure
% tt=24;
% plot(F(:,tt)./BG);hold on;
% line([spks{tt}; spks{tt}],[ones(1,length(spks{tt})); .05+max(F(:,tt)./BG).*ones(1,length(spks{tt}))],...
%     'LineWidth',2);

%% Set s values

s.rstr = rstr;       % raster plot
s.F_cell=F;     % fluorescence
s.amplitudes=amplitudes;
% s.F_cell=medfilt1(F./repmat(BG,1,size(F,2)),3);   
s.Spikes_cell = spks;  % spike times
s.fps=20;
s.BG=BG;
s.BG_noise=BG_noise;
s.baseline=baseline;
s.baseline_locs=baseline_locs;
s.peak_locs=peak_locs;
