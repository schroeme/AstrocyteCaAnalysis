function corrs=corr_lagged(x,y,lag,ind)
%Usage: [corr,lag]=ami(x,y,lag)
%
% Calculates the Pearson's correlation coefficient between x and y with a possible lag.
% 
%
% x & y is the time series. (column vectors)
% lag is a vector of time lags.

if nargin > 3; %correlation of ctrl time series (pairs)
    curr_lag = lag(ind);
        if ind <= length(lag)/2 %positive lag - x lagged relative to y
            x_lagged = x(1+curr_lag:end,:); %2D
            corrs = corr(x_lagged,y(1:length(x_lagged),:));
        else  %negative lag - y lagged relative to x
            y_lagged = y(1+curr_lag:end,:); %2D
            corrs = corr(x(1:length(y_lagged),:),y_lagged);
        end
else %correlation of 1D time series (all)
    corrs=zeros(size(x,2),size(y,2),length(lag)); %will be a 3D matrix
    for ii=1:length(lag)
        curr_lag = lag(ii);
        if ii <= length(lag)/2 %positive lag - x lagged relative to y
            x_lagged = x(1+curr_lag:end,:);
            corrs(:,:,ii) = corr(x_lagged,y(1:length(x_lagged),:));
        else  %negative lag - y lagged relative to x
            y_lagged = y(1+curr_lag:end,:); %2D
            corrs(:,:,ii) = corr(x(1:length(y_lagged),:),y_lagged);
        end
    end
end
    
