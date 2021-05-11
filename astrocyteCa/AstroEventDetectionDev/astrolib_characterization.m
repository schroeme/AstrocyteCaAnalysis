%% characterization of library waveforms
% for thesis. what do these traces have in common?

%% first plot them
counter = 0;
for tindex = 1:length(astrospikes)
    counter = counter + 1;
    N = length(astrospikes{tindex});
    if mod(tindex-1,28) == 0
        figure()
        counter = 1;
    end
    subplot(7,4,counter)
    plot([(1:N)./20],astrospikes{tindex})
    xlabel('Time (s)')
    ylabel('F/F_0')
end 

%% Complex magnitude analysis

for tindex = 1:length(astrospikes)
    
    Fs = 20;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    L = length(astrospikes{tindex});             % Length of signal
    f = Fs*(0:(L/2))/L      %frequency vector
    
    trace = astrospikes{tindex}-astrospikes{tindex}(1);
    Y = fft(trace);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
%     figure(tindex)
%     plot(f,P1) 
%     title('Single-Sided Amplitude Spectrum of X(t)')
%     xlabel('f (Hz)')
%     ylabel('|P1(f)|')
%     
    [pmax(tindex,1),ind]=max(P1);
    %f=f(2:end);
    fmax(tindex,1) = f(ind);
end

%% k means clustering
%eva = evalclusters(fmax,'kmeans','gap','KList',[1:100]);
%get out k optimal = 38
groupidx = kmeans(fmax,38);
figure
colors = distinguishable_colors(max(groupidx));
%plot(fmax(groupidx==1),pmax(groupidx==1),'.','MarkerSize',10)
hold on
for kindex = 1:max(groupidx)
    %counter=counter+1;
    plot(fmax(groupidx==kindex),pmax(groupidx==kindex),'.','MarkerSize',20,'Color',colors(kindex,:))
    %if rem(kindex,length(colors))==0
        %counter = 0;
    %end
end
hold off
