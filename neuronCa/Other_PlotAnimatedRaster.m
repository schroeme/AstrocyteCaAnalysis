%% Make animation of raster generation
close all
clear all

neuron = 23;

load('A:\20160610_Exp166_Injury\D01\island3\networkdata\processed_analysis_spikech_reg_actfilt_netw');
x=analysis(1).spikedata.F_cell(:,neuron);
y = analysis(1).spikedata.Spikes_cell{neuron};
y = y([1,4,5,7]);

nframes=length(x);
spikesvector=zeros(1,nframes);
spikesvector(y)=1;


RasterFig=figure();
set(RasterFig, 'Position', [100, 100, 400, 400]);
axis([0 length(x)/20 0 size(analysis(1).spikedata.F_cell,2)]);
set(gca,'ytick',[1 23 size(analysis(1).spikedata.F_cell,2)]);
set(gca,'xtick',[1 50 100 150 length(x)]);
set(gca,'FontSize',20);
xlabel('Time (sec)');
ylabel('Neuron #');

v = VideoWriter('raster.avi');
v.FrameRate = 80;
open(v);
set(gca,'nextplot','replacechildren')

for k = 1:nframes                              
    % add to line
    if(spikesvector(k))
        plot(k/20,neuron,'.k'); hold on
    end
    % update screen
    drawnow  
    
    F(k)=getframe(gcf);
    writeVideo(v,F(k));
end
close (v)

RasterFig2=figure();
set(RasterFig2, 'Position', [100, 100, 450, 400]);
axis([0 length(x)/20 0 size(analysis(1).spikedata.F_cell,2)]);
set(gca,'ytick',[1 23 size(analysis(1).spikedata.F_cell,2)]);
set(gca,'xtick',[1 50 100 150 length(x)]);
set(gca,'FontSize',20);
xlabel('Time (sec)');
ylabel('Neuron #');

datastruct=analysis(1).spikedata.Spikes_cell; 
for ind = 1:numel(datastruct) 
    time=datastruct{ind}';
    neuron=ind*ones(length(time),1);
          
    plot(time/20, neuron,'.k'); hold on
end

          set(gca,'FontSize',20);
xlabel('Time (sec)');
ylabel('Neuron #');
axis([0 length(x)/20 0 size(analysis(1).spikedata.F_cell,2)]);
set(gca,'ytick',[1 23 size(analysis(1).spikedata.F_cell,2)]);
set(gca,'xtick',[1 50 100 150 length(x)]);
 



