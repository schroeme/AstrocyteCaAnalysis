function astroLibraryProcessing()

%astrotrace_lib -- structure containing example traces      
load([pwd filesep 'astrotrace_lib.mat']);
    
%% Smooth the library signals

for i=1:length(astrotrace_lib)
    smoothtrace{i,1}=smooth(smooth(smooth(smooth(astrotrace_lib{i}))));
    figure(i)
    plot(smoothtrace{i})
end 

%plot smoothed traces to view them
%plot(smoothtrace{i})

% %% Estimage Background Noise
% 
% for i=1:length(astrotrace_lib)
%     Fo(i,1)=min(astrotrace_lib{i});
% end
% 
% BG_mod=fit([1:size(astrotrace_lib,2)]',Fo,'linearinterp');
% coefs=mean(BG_mod.p.coefs);
% 
% BG_linfit=(1:size(Fo)).*coefs(1)+coefs(2);
% 
% BG=BG_linfit';
% 
% [b,a]=butter(15,1/10,'high');
% BG_noise=5*std(filtfilt(b,a,mean(Fo,2)))/mean(BG);
% 
% %% Calculate SNR of raw traces
% 
% for xx=1:size(astrotrace_lib,2)
%     x=astrotrace_lib{:,xx}./BG(xx);
%     % Estimate SNR of signal
%     snr_win=[5:25:200 500 1000 2000];
%     x_std_cell=cell(length(snr_win),1);
%     for yy_tmp=1:length(snr_win)
%         x_std_cell{yy_tmp}=zeros(size(x,1)-snr_win(yy_tmp),1);
%         for xx_tmp=1:size(x_std_cell{yy_tmp},1); 
%             x_std_cell{yy_tmp}(xx_tmp)=std(x(xx_tmp:(xx_tmp+snr_win(yy_tmp)))); 
%         end
%         SNR_tmp(yy_tmp)=prctile(x_std_cell{yy_tmp},99)./prctile(x_std_cell{yy_tmp},1);
%     end
%     SNR=std(~isnan(SNR_tmp));
% end 

%% Choose snipets of the signals to work with

timewindow = 2*20;%in frames per second
for i=1:length(astrotrace_lib)
    [pks{i},locs{i}]=findpeaks(smoothtrace{i},'MinPeakHeight',.99*max(smoothtrace{i}));
    snippet_indices{i,1} = [locs{i}-timewindow locs{i}+timewindow];
    for k=1:size(snippet_indices{i},1)
        snippets{i,k}=smoothtrace{i}(snippet_indices{i}(k,1):snippet_indices{i}(k,2));
    end 
end

snippets_col=reshape(snippets,numel(snippets),1);
snippets_col=snippets_col(~cellfun('isempty',snippets_col));

processed_astrotracelib = snippets_col;
save([pwd filesep 'procssed_astrotracelib'])
    

%% Plot a couple snippets

for i=1:10
    subplot(2,5,i)
    plot(snippets_col{i})
    axis([0 81 min(snippets_col{i}) max(snippets_col{i})])
    xlabel('frames')
    ylabel('F/F_0')
end


