function [count] = Stochastic(value,data,limit)
N=length(data);
data2=data(1:limit);
ocurrences=strfind(data2, value); 
count=length(ocurrences);
count=count*(N/limit);
end

