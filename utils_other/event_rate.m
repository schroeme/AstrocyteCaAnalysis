function ER = event_rate(cellarr,tlength)
%quick calculation of event rate once we already have the spike data

for cc = 1:length(cellarr)
    nspikes(cc,1) = size(cellarr{cc},2);
end

rates = nspikes./(tlength/(20*60));
ER = nanmean(rates);

end