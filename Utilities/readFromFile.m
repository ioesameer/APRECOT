% I wrote this code myself but I can't understand it for now. I guess I 
%  can understand later
fid= fopen(inputFileName)
dataInputs= textscan(fid,'%s','CommentStyle','%','delimiter','\n');
dataInputs = [dataInputs{:}];
temp=regexp(dataInputs,'\d+(\.)?(\d+)?','match');
readData=str2double([temp{:}]);
fclose(fid);


