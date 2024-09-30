clear,clc,

str = fileread('test.txt');
rgx = sprintf('\\s+%c([+-]?\\d+\\.?\\d*)','XYE');
tkn = regexp(str,rgx,'tokens');
mat = str2double(vertcat(tkn{:}))