%% Make animation of trace generation
close all
clear all

neuron = 23;

load('A:\20160610_Exp166_Injury\D01\island3\networkdata\processed_analysis_spikech_reg_actfilt_netw');
x = (analysis(1).spikedata.F_cell(:,23)./analysis(1).spikedata.BG);
background=analysis(1).spikedata.BG;
nframes=length(x);

y = analysis(1).spikedata.Spikes_cell{neuron};
y = y([1,4,5,7]);
peaksvector=zeros(1,nframes);
peaksvector(y)=1;


fname='A:\20160610_Exp166_Injury\D01\island3\D01_div11_island3.tif';
info=imfinfo(fname);


%nframes=1200;
%F(1:nframes)=struct('cdata',[],'colormap',[]);

TraceFig=figure();
set(TraceFig, 'Position', [100, 100, 400, 400]);
%subplot(2,1,1)

%subplot(2,1,2)
a1 = animatedline('Color','k');
axis([0 length(x)/20 1.19 1.8])
set(gca,'ytick',[])
set(gca,'FontSize',20);
xlabel('Time (sec)');
ylabel('F/F0');


% v2=VideoReader('A:\Codes\CaDataAnalysis\D01_div11_island3_green.avi')
% sz = [vid.Height v2.Width];
% mov = read(v2, [1 v2.NumberOfFrames]);

%movie(mov,1,20); 

% v = VideoWriter('trace.avi','Uncompressed AVI');
v = VideoWriter('trace.avi');
v.FrameRate = 80;
open(v);
set(gca,'nextplot','replacechildren')

for k = 1:nframes
    
%     subplot(2,1,1)
%     [A,map]=imread(fname,k);
%     A=uint8(A);
%     %background = imopen(A,strel('disk',15));
%     A_histeq = histeq(A);
%     A_adapthisteq = adapthisteq(A);
%     imshow(A-background,map,'Border','tight','InitialMagnification', 150);
%     imshow(A,map);
%     drawnow
    
%     subplot(2,1,2)
    % add to line
    addpoints(a1,k/20,x(k));
    
    % update screen
    drawnow 
    
    F(k)=getframe(gcf);
    writeVideo(v,F(k));
end
close (v)


% figure(2)
% set(gca,'xtick',[],'ytick',[])
% axis([0 1500 1.1 1.5])
% movie(gcf,F);
% 
% % % figure(3)
% % % axis([0 1500 1.1 1.5])
% % % set(gca,'xtick',[],'ytick',[])
% v = VideoWriter('peaks.avi');
% v.FrameRate = 20;
% open(v);
% for k = 1:1500
%    writeVideo(v,F(k));
% end
% close(v);