function CaAnalysisRoutine_Alex_Margaret()

clear all
close all

allfolders={
% %             'E:\MargaretFall2018\MargaretSpring2018Data\2-9-18_cag\D01';
% %             'E:\MargaretFall2018\MargaretSpring2018Data\2-9-18_cag\D02';
% %             'E:\MargaretFall2018\MargaretSpring2018Data\2-9-18_cag\D03';
% %             'E:\MargaretFall2018\MargaretSpring2018Data\2-9-18_cag\D04';
% %             'E:\MargaretFall2018\MargaretSpring2018Data\2-9-18_cag\D05';
% 
% %BASELINE
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01';
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02';
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03';
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01';
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02';
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01';
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02';
%               'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03';
% 
% 'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01';
% 'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02';
% 'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03';
% 'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04';
% 'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05';
% % % 
% 'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01';
% 'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02';
              %INJURY PERIODS

%               %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D01\PostInjury06';
%                  %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D02\PostInjury05';
% % % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_3-30-18\D03\PostInjury08';
% % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\Injury01';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\Injury02';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\Injury03';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\Injury04';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\Injury05';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\Injury06';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\Injury07';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\PostInjury01';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\PostInjury02';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\PostInjury03';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\PostInjury04';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\PostInjury05';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\PostInjury06';
%                     'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D01\PostInjury07';
% % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\Injury02';
%                         %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\Injury03';
%                         %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-4-18\D02\PostInjury04';
% % % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D01\PostInjury06';
% % % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D02\PostInjury10';
% % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-11-18\D03\PostInjury07';
% % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\Injury09'
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D01\PostInjury10';
% % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury10';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury11';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\Injury12';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury10';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury11';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D02\PostInjury12';
% % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\Injury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D03\PostInjury09';
% % %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D04\PostInjury07';
% %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-13-18\D05\PostInjury08';
% %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury10';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\Injury11';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury10';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D01\PostInjury11';
% %                 %'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury10';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\Injury11';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury01';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury02';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury03';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury04';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury05';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury06';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury07';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury08';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury09';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury10';
%                         'J:\MeaneyLab\MSchroeder\DataAnalyzed\MargaretSpring2018Data\S18_inj_correlation\Injury_4-20-18\D02\PostInjury11';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\3-30\D01';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\3-30\D02';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\3-30\D03';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-4\D01';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-4\D02';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-11\D01';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-11\D02';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-11\D03';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-13\D01';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-13\D02';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-13\D03';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-13\D04';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-13\D05';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-20\D01';
%                             'E:\MargaretSpring2018Data\S18_inj_correlation_baseline\4-20\D02';
% %          'E:\MargaretFall2018\Injury_9-18-18\D01';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\Injury01';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\Injury02';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\Injury03';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\Injury04';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\Injury05';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\Injury06';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\PostInjury01';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\PostInjury02';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\PostInjury03';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\PostInjury04';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\PostInjury05';
%                 'E:\MargaretFall2018\Injury_9-18-18\D01\PostInjury06';
%         %'E:\MargaretFall2018\Injury_9-18-18\D02';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\Injury01';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\Injury02';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\Injury03';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\Injury04';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\PostInjury01';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\PostInjury02';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\PostInjury03';
%                 'E:\MargaretFall2018\Injury_9-18-18\D02\PostInjury04';
%         %'E:\MargaretFall2018\Injury_9-18-18\D03';
%                 'E:\MargaretFall2018\Injury_9-18-18\D03\Injury01';
%                 'E:\MargaretFall2018\Injury_9-18-18\D03\Injury02';
%                 'E:\MargaretFall2018\Injury_9-18-18\D03\Injury03';
%                 'E:\MargaretFall2018\Injury_9-18-18\D03\PostInjury01';
%                 'E:\MargaretFall2018\Injury_9-18-18\D03\PostInjury02';
%                 'E:\MargaretFall2018\Injury_9-18-18\D03\PostInjury03';
% 
        'E:\MargaretFall2018\Injury_10-11-18\D01';
        'E:\MargaretFall2018\Injury_10-11-18\D02';
        'E:\MargaretFall2018\Injury_10-11-18\D03';
        'E:\MargaretFall2018\Injury_10-11-18\D04';
        'E:\MargaretFall2018\Injury_10-11-18\D05';
        'E:\MargaretFall2018\Injury_10-11-18\D06';
        'E:\MargaretFall2018\Injury_10-11-18\D07';
        'E:\MargaretFall2018\Injury_10-11-18\D08';

        'E:\MargaretFall2018\Injury_10-25-18\D01';
        'E:\MargaretFall2018\Injury_10-25-18\D02';
        'E:\MargaretFall2018\Injury_10-25-18\D04';

        'E:\MargaretFall2018\Injury_11-1-18\D01';
        'E:\MargaretFall2018\Injury_11-1-18\D02';
        'E:\MargaretFall2018\Injury_11-1-18\D03';
        'E:\MargaretFall2018\Injury_11-1-18\D04';
        'E:\MargaretFall2018\Injury_11-1-18\D05';
        'E:\MargaretFall2018\Injury_11-1-18\D06';
        'E:\MargaretFall2018\Injury_11-1-18\D07';
        'E:\MargaretFall2018\Injury_11-1-18\D08';
% 
        'E:\MargaretFall2018\Injury_11-29-18\D01';
        'E:\MargaretFall2018\Injury_11-29-18\D02'; %no astros
        'E:\MargaretFall2018\Injury_11-29-18\D03'; 
        'E:\MargaretFall2018\Injury_11-29-18\D04';%no astros
% 
    'E:\Margaret_Spring2019\Injury_1-24-19\D01';
    'E:\Margaret_Spring2019\Injury_1-24-19\D02';
    'E:\Margaret_Spring2019\Injury_1-24-19\D03';
    'E:\Margaret_Spring2019\Injury_1-24-19\D04';
    'E:\Margaret_Spring2019\Injury_1-24-19\D05';
    'E:\Margaret_Spring2019\Injury_1-24-19\D07';
    'E:\Margaret_Spring2019\Injury_1-24-19\D08';

% 'E:\Margaret_Spring2019\Injury_1-31-19\D01';
% 'E:\Margaret_Spring2019\Injury_1-31-19\D02';
% 'E:\Margaret_Spring2019\Injury_1-31-19\D03';
% 'E:\Margaret_Spring2019\Injury_1-31-19\D04';
% 'E:\Margaret_Spring2019\Injury_1-31-19\D05';
% 'E:\Margaret_Spring2019\Injury_1-31-19\D06';
             }; 

acqrate=20;                          %acquisition rate for recording
%threshold=0.85;                     %threshold for spike detection

for folderno=1:length(allfolders)
    
    folder=allfolders{folderno};
    tic
    %RAW DATA ANALYSIS
    %RawDataAnalysis_Alex(folder,acqrate);
    %Other_FixOrderOfConditions_Alex(folder);
    %PhenotypingAnalysis_CalculateFullFieldFluorescence(folder);
    %PhenotypingAnalysis_PlotFullFieldFluorescence(folder,20);
    %CropAnalysisFileForInjured(folder);
    %toc
    
    %ASTROCYTE IDENTIFICATION
    %Other_PlotSegmFromMatrix_Alex(folder);
    %toc
    %assignAstrocytes_MES(folder);
    %Astrocytes_GUI();
    %CollectAstrocyteTraces(folder);
    %removeFalseAstros_MES(folder);
    
    %INJURY WORKFLOW
    %TapInjury_times_GUI
    %Create_TapInjury_Videos(folder);
    
    %SPIKE DETECTION
    %SpikeAnalysis_neuroastro_MS(folder);
    %SpikeAnalysis_Alex_forMattsCode(folder);
    %SpikeAnalysis_neuroastro_inj_MS(folder);
    %CorrectForFalsePeaks_Alex_MES_inj(folder);
    %CorrectForFalsePeaks_Alex(folder);
    %CorrectForFalsePeaks_Alex_MES_astros(folder);
    
    %REGISTRATION
    %RegisterSegmentations_GenerateCorrelationMap_Step1_Alex(folder);
    %RegisterSegmentations_GenerateCorrelationMap_Step2_Alex(folder);
    %RegisterSegmentations_Renumber_Alex(folder);
    
    %DOWNSTREAM PROCESSING
    %Raster_MES(folder);
    %EliminateNonactiveNeurons_Alex_MS(folder);
    %[nactivesegments(folderno),nactivecells(folderno)]=EliminateNonactiveAstrosFC(folder)
    
    %Granger Causality
    %neuroastro_causality_MES(folder,100);
    %neuroastro_causality_inj_MES(folder)
    %neuroastro_causality_inj_ctrl_MES(folder)
    %mvgc_MS(folder)
    
    %BURSTING
    %CreateDataCellMES(folder);
    %RunISIMES(folder)
    %BurstDetectionMES(folder);
    
    %NeuronAstroDistance(folder);
    %spatial_distances(folder)
    %NumberofEventsMES_dish(folder);   
    
    %NETWORK PARAMETERS
    %generate_weight_matrix(folder,1);
    %generate_weight_matrix_astros(folder,1,1000,100);
    generate_weight_matrix_multilayer(folder,1000,100);
%     generate_weight_matrix_v2(folder,500,50)
    toc
    
    %Network_Connectivity_Alex_MS(folder,1);                 %second input argument is index for the use of "parfor"
    %Network_Parameters_Alex(folder);
    %Other_PlotNetworksFromMatrix(folder);
    %Network_Synchronization_Alex_MS(folder,0);
    %Network_Synchronization_Alex_MS_inj(folder,0);
    %Network_Synchronization_ForMattsCode_MS(folder);
    %Network_Modularity_Alex(folder)
    
    %toc
    %FrequencyAnalysis_Alex(folder);
    %FrequencyAnalysisAutomated_Alex(folder,acqrate);
    %FrequencyAnalysis_ClusterAnalysis_Alex(folder,acqrate);
    %FrequencyAnalysis_Plots_Alex(folder,acqrate);
    %toc
    %Other_PlotHistogramFromMatrix(folder);
    %Other_PlotRasterFromMatrix(folder,acqrate);
    %toc
    %Other_PlotRasterVsConnectivityFromMatrix(folder,acqrate);
    %toc
    %CheckPeakDetection_MES(folder);
    
    %ASTROCYTES
    %NeuronAstroTraceMES(folder);
    %NeuronAstroRaster_MES(folder);
    %NeuronAstroNumberofEventsMES(folder);
    
    %Experiment-wide analysis below
    %ExperimentFolder = 'A:\MargaretFall2017Data\Exp327';
    %Create_SummaryMES(allfolders,ExperimentFolder);
    %NumberofEventsMES(ExperimentFolder);
    %SynchroSummaryMES(ExperimentFolder);
    %BurstSummaryMES(ExperimentFolder,allfolders);

end

end
