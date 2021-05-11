function mvgc_MS(folderpath)

%%MODIFIED FROM: MVGC demo
% References
%
% [1] L. Barnett and A. K. Seth,
% <http://www.sciencedirect.com/science/article/pii/S0165027013003701 The MVGC
%     Multivariate Granger Causality Toolbox: A New Approach to Granger-causal
% Inference>, _J. Neurosci. Methods_ 223, 2014
% [ <matlab:open('mvgc_preprint.pdf') preprint> ].
%
% [2] A. B. Barrett, L. Barnett and A. K. Seth, "Multivariate Granger causality
% and generalized variance", _Phys. Rev. E_ 81(4), 2010.
%
% [3] L. Barnett and A. K. Seth, "Behaviour of Granger causality under
% filtering: Theoretical invariance and practical application", _J. Neurosci.
% Methods_ 201(2), 2011.
%
% (C) Lionel Barnett and Anil K. Seth, 2012. See file license.txt in
% installation directory for licensing terms.
disp(folderpath)
load([folderpath filesep 'processed_analysis_inj_spikech_actfilt.mat']);

%
%% Parameters
for cindex = 1:1
    if ~isempty(analysis(cindex).aspikedata.F_cell)
        nneuros = size(analysis(cindex).nspikedata.F_cell,2);
        nastros = size(analysis(cindex).aspikedata.F_cell,2);
%         BGn=repmat(analysis(cindex).nspikedata.BG,1,nneuros);
%         BGa=repmat(analysis(cindex).aspikedata.BG,1,nastros);
%         traces = [analysis(cindex).nspikedata.F_cell./BGn analysis(cindex).aspikedata.F_cell./BGa]';
        traces = [analysis(cindex).nspikedata.F_cell analysis(cindex).aspikedata.F_cell]';
        ntrials   = 1;     % number of trials
        nobs      = size(traces,2);   % number of observations per trial


        %make sure that each row is unique
        [uniquetraces,ia,ic]=unique(traces,'rows','stable');
        if size(uniquetraces,1) ~= size(traces,1) %we have repeats
            %return indices in the full that are not in reduced
            repeats=setdiff(1:nneuros+nastros,ia);
            neurorepeats=ic(repeats); %first occurence of repeated thing
        %     for rr=1:length(repeats)
        %         neurorepeats(rr,1)=find(ia==repeats(rr)); %what neurons are these? they are actually astros
        %     end
            tracestoget=setdiff(1:size(traces,1),neurorepeats);
            traces = traces(tracestoget,:);
            nneuros = nneuros-length(neurorepeats);
        end

        regmode   = 'OLS';  % VAR model estimation regression mode ('OLS', 'LWR' or empty for default)
        icregmode = 'LWR';  % information criteria regression mode ('OLS', 'LWR' or empty for default)

        morder    = 'BIC';  % model order to use ('actual', 'AIC', 'BIC' or supplied numerical value)
        momax     = 20;     % maximum model order for model order estimation
%         morder = 20;
        
        if nobs >= 200
            acmaxlags = 200;   % maximum autocovariance lags (empty for automatic calculation)
        else
            acmaxlags = 50;
        end
        
        tstat     = '';     % statistical test for MVGC:  'F' for Granger's F-test (default) or 'chi2' for Geweke's chi2 test
        alpha     = 0.05;   % significance level for significance test
        mhtc      = 'FDR';  % multiple hypothesis test correction (see routine 'significance')

        fs        = 20;    % sample rate (Hz)
        fres      = [];     % frequency resolution (empty for automatic calculation)
        
        ev        = 10;      % evaluate GC at every ev-th sample
        wind      = 20;       % observation regression window size

        X = reshape(traces,[nneuros+nastros,nobs,ntrials]);
        if size(X,1) >= 2;

            %% Model order estimation (<mvgc_schema.html#3 |A2|>)

            % Calculate information criteria up to specified maximum model order.

            %ptic('\n*** tsdata_to_infocrit\n');
            %[AIC,BIC,moAIC,moBIC] = tsdata_to_infocrit(X,momax,icregmode);
            %ptoc('*** tsdata_to_infocrit took ');

            % Plot information criteria.
            
%             figure(1); clf;
%             plot_tsdata([AIC BIC]',{'AIC','BIC'},1/fs);
%             title('Model order estimation');


%             fprintf('\nbest model order (AIC) = %d\n',moAIC);
%             fprintf('best model order (BIC) = %d\n',moBIC);
%             fprintf('actual model order     = %d\n',amo);

            % Select model order.

%             if     strcmpi(morder,'actual')
%                 morder = amo;
%                 fprintf('\nusing actual model order = %d\n',morder);
%             elseif strcmpi(morder,'AIC')
%                 morder = moAIC;
%                 fprintf('\nusing AIC best model order = %d\n',morder);
%             elseif strcmpi(morder,'BIC')
%                 morder = moBIC;
%                 fprintf('\nusing BIC best model order = %d\n',morder);
%             else
%                 fprintf('\nusing specified model order = %d\n',morder);
%             end
            morder=20;

            %% VAR model estimation (<mvgc_schema.html#3 |A2|>)

            % Estimate VAR model of selected order from data.

            %ptic('\n*** tsdata_to_var... ');
            %[A,SIG] = tsdata_to_var(X,morder,regmode);
            %ptoc;

            % Check for failed regression

            %assert(~isbad(A),'VAR estimation failed');

            % NOTE: at this point we have a model and are finished with the data! - all
            % subsequent calculations work from the estimated VAR parameters A and SIG.

            %% Autocovariance calculation (<mvgc_schema.html#3 |A5|>)

            % The autocovariance sequence drives many Granger causality calculations (see
            % next section). Now we calculate the autocovariance sequence G according to the
            % VAR model, to as many lags as it takes to decay to below the numerical
            % tolerance level, or to acmaxlags lags if specified (i.e. non-empty).

            ptic('*** tsdata_to_autocov... ');
            G = tsdata_to_autocov(X,acmaxlags);
            ptoc;

            % The above routine does a LOT of error checking and issues useful diagnostics.
            % If there are problems with your data (e.g. non-stationarity, colinearity,
            % etc.) there's a good chance it'll show up at this point - and the diagnostics
            % may supply useful information as to what went wrong. It is thus essential to
            % report and check for errors here.

            %var_info(info,true); % report results (and bail out on error)

            %% Granger causality calculation: time domain  (<mvgc_schema.html#3 |A13|>)

            % Calculate time-domain pairwise-conditional causalities - this just requires
            % the autocovariance sequence.

            ptic('*** autocov_to_pwcgc... ');
            F = autocov_to_pwcgc(G);
            ptoc;

            % Check for failed GC calculation

            assert(~isbad(F,false),'GC calculation failed');

            % Significance test using theoretical null distribution, adjusting for multiple
            % hypotheses.
            nvars=size(F,1);
            pval = mvgc_pval(F,morder,nobs,ntrials,1,1,nvars-2,tstat); % take careful note of arguments!
            sig  = significance(pval,alpha,mhtc);

            % Plot time-domain causal graph, p-values and significance.

            % figure(2); clf;
            % subplot(1,3,1);
            % plot_pw(F);
            % title('Pairwise-conditional GC');
            % subplot(1,3,2);
            % plot_pw(pval);
            % title('p-values');
            % subplot(1,3,3);
            % plot_pw(sig);
            % title(['Significant at p = ' num2str(alpha)])

            % For good measure we calculate Seth's causal density (cd) measure - the mean
            % pairwise-conditional causality. We don't have a theoretical sampling
            % distribution for this.
%             wnobs = morder+wind;   % number of observations in "vertical slice"
%             ek    = wnobs:ev:nobs; % GC evaluation points
%             enobs = length(ek);    % number of GC evaluations
% 
%             F12 = nan(enobs,1);
%             F21 = nan(enobs,1);
% 
%             % loop through evaluation points
% 
%             for e = 1:enobs
%                 j = ek(e);
%                 fprintf('window %d of %d at time = %d',e,enobs,j);
% 
%                 [A,SIG] = tsdata_to_var(X(:,j-wnobs+1:j,:),morder,regmode);
%                 if isbad(A)
%                     fprintf(2,' *** skipping - VAR estimation failed\n');
%                     continue
%                 end
% 
%                 [G,info] = var_to_autocov(A,SIG);
%                 if info.error
%                     fprintf(2,' *** skipping - bad VAR (%s)\n',info.errmsg);
%                     continue
%                 end
%                 if info.aclags < info.acminlags % warn if number of autocov lags is too small (not a show-stopper)
%                     fprintf(2,' *** WARNING: minimum %d lags required (decay factor = %e)',info.acminlags,realpow(info.rho,info.aclags));
%                 end
% 
%                 FF = autocov_to_pwcgc(G);
%                 if isbad(FF,false)
%                     fprintf(2,' *** skipping - GC calculation failed\n');
%                     continue
%                 end
% 
%                 F12(e) = FF(1,2); % estimated GC 2 -> 1 (significant)
%                 F21(e) = FF(2,1); % estimated GC 1 -> 2 (non-significant)
% 
%                 fprintf('\n');
%             end
% 
%             % theoretical GC 2 -> 1
% 
%             D = 1+b^2 + c(ek).^2;
%             F12T = log((D + sqrt(D.^2 - 4*b^2))/2)';
% 
%             % critical GC value at significance alpha, corrected for multiple hypotheses
% 
%             nhyp = 2; % number of hypotheses (i.e. 2 -> 1 and 1 -> 2)
%             switch upper(mhtc)
%                 case 'NONE',       alpha1 = alpha;
%                 case 'BONFERRONI', alpha1 = alpha/nhyp;
%                 case 'SIDAK',      alpha1 = 1-realpow(1-alpha,1/nhyp);
%                 otherwise, error('unhandled correction method ''%s''',mhtc);
%             end
% 
%             Fc = mvgc_cval(alpha1,morder,wnobs,ntrials,1,1,nvars-2);

            % plot GCs

            cd = mean(F(~isnan(F)));
            fprintf('\ncausal density = %f\n',cd);

            %to is rows, columns is from
            cd_na = mean(mean(F(1:nneuros,nneuros+1:end))); %to neurons, from astros
            cd_an = mean(mean(F(nneuros+1:end,1:nneuros)));

            pc_na = mean(mean(sig(1:nneuros,nneuros+1:end)));
            pc_an = mean(mean(sig(nneuros+1:end,1:nneuros)));


            % %% Granger causality calculation: frequency domain  (<mvgc_schema.html#3 |A14|>)
            % 
            % % Calculate spectral pairwise-conditional causalities at given frequency
            % % resolution - again, this only requires the autocovariance sequence.
            % 
            % ptic('\n*** autocov_to_spwcgc... ');
            % f = autocov_to_spwcgc(G,fres);
            % ptoc;
            % 
            % % Check for failed spectral GC calculation
            % 
            % assert(~isbad(f,false),'spectral GC calculation failed');
            % 
            % % Plot spectral causal graph.
            % 
            % figure(3); clf;
            % plot_spw(f,fs);
            % 
            % %% Granger causality calculation: frequency domain -> time-domain  (<mvgc_schema.html#3 |A15|>)
            % 
            % % Check that spectral causalities average (integrate) to time-domain
            % % causalities, as they should according to theory.
            % 
            % fprintf('\nchecking that frequency-domain GC integrates to time-domain GC... \n');
            % Fint = smvgc_to_mvgc(f); % integrate spectral MVGCs
            % mad = maxabs(F-Fint);
            % madthreshold = 1e-5;
            % if mad < madthreshold
            %     fprintf('maximum absolute difference OK: = %.2e (< %.2e)\n',mad,madthreshold);
            % else
            %     fprintf(2,'WARNING: high maximum absolute difference = %e.2 (> %.2e)\n',mad,madthreshold);
            % end
            % 
            % %%
            % % <mvgc_demo.html back to top>

            analysis(cindex).GC.F=F;
            analysis(cindex).GC.pval=pval;
            analysis(cindex).GC.cd_na = cd_na;
            analysis(cindex).GC.cd_an = cd_an;
            analysis(cindex).GC.pc_na = pc_na;
            analysis(cindex).GC.pc_an = pc_an;
        else
            disp('Too few active cells :(')
            analysis(cindex).GC.F=[];
            analysis(cindex).GC.pval=[];
            analysis(cindex).GC.cd_na = [];
            analysis(cindex).GC.cd_an = [];
            analysis(cindex).GC.pc_na = [];
            analysis(cindex).GC.pc_an = [];
        end
    else
        disp('No active astros :(')
        analysis(cindex).GC.F=[];
        analysis(cindex).GC.pval=[];
        analysis(cindex).GC.cd_na = [];
        analysis(cindex).GC.cd_an = [];
        analysis(cindex).GC.pc_na = [];
        analysis(cindex).GC.pc_an = [];
    end
end

save([folderpath filesep 'processed_analysis_astrocheck_spikech_GC2'],'analysis')