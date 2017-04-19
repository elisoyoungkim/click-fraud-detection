function accuracyTS=FraudDetection(nTrees)
% Import datasets for training set
% Fraud dataset
filename = 'newFeatures.csv';
fid = fopen(filename,'rt');
[Fraud]=textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %d',...
       'headerlines', 1,...
       'delimiter',',',...
       'TreatAsEmpty','NA',...
       'EmptyValue', NaN);                              
fclose(fid);
featuresFraud = [Fraud{2} Fraud{3} Fraud{4} Fraud{5} Fraud{6} Fraud{7} Fraud{8} Fraud{9} Fraud{10} Fraud{11} Fraud{12} Fraud{13}];
partneridFraud = Fraud{1};

% Normal dataset
filename = 'newFeaturesOK.csv';
fid = fopen(filename,'rt');
[OK]=textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %d',...
       'headerlines', 1,...
       'delimiter',',',...
       'TreatAsEmpty','NA',...
       'EmptyValue', NaN);                              
fclose(fid);
featuresOK = [OK{2} OK{3} OK{4} OK{5} OK{6} OK{7} OK{8} OK{9} OK{10} OK{11} OK{12} OK{13}];
partneridOK = OK{1};

classTR = [Fraud{14}; OK{14}];

% Combine Fraud and Normal datasets
Mat = [featuresFraud; featuresOK];
% In array, only same data type can be put (partnerID is string)
partnerID = [partneridFraud; partneridOK];

% Load test dataset
filename = 'newFeaturesTest.csv';
fid = fopen(filename,'rt');
[ts]=textscan(fid, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f',...
       'headerlines', 1,...
       'delimiter',',',...
       'TreatAsEmpty','NA',...
       'EmptyValue', NaN);                              
fclose(fid);

testSet = [ts{2} ts{3} ts{4} ts{5} ts{6} ts{7} ts{8} ts{9} ts{10} ts{11} ts{12} ts{13}];
partneridTest = ts{1};

% Load labeld test set for evaluation
filename = 'labeledTS.csv';
fid = fopen(filename,'rt');
[TS]=textscan(fid, '%s %d',...
       'headerlines', 1,...
       'delimiter',',',...
       'TreatAsEmpty','NA',...
       'EmptyValue', NaN);                              
fclose(fid);

classTS = [TS{2}];
partnerid_classTS = TS{1};

features = Mat(:,(1:12));
 
% The number of trees in the forest 
nTrees = 300;
 
% Train the TreeBagger (Decision Forest)
B = TreeBagger(nTrees,features,classTR, 'Method', 'classification');
 
% newData = [230	155	60	4.8807	0.256	3.1813	1.0044	1.1111	1.0088	1.0044	1.0044	1.0084];

predictedClass = [];
for i=1:length(testSet)
    newData = testSet(i,:);
    predictedClass = [predictedClass; str2double(B.predict(newData))]
end

correct_outputNormal=0;
correct_outputFraud=0;
incorrect_outputNormal=0;
incorrect_outputFraud=0;

for i=1:length(classTS)
    if predictedClass(i) == 0
        if classTS(i) == predictedClass(i)
            correct_outputNormal = correct_outputNormal + 1;
        else
            incorrect_outputNormal = incorrect_outputNormal + 1;
        end
    else
        if classTS(i) == predictedClass(i)
            correct_outputFraud = correct_outputFraud + 1;
        else
            incorrect_outputFraud = incorrect_outputFraud + 1;
        end
    end
end
            
cMatrix = [correct_outputNormal incorrect_outputNormal;
           incorrect_outputFraud correct_outputFraud];
accuracyTS = (cMatrix(1,1)+cMatrix(2,2))./sum(sum(cMatrix)).*100;