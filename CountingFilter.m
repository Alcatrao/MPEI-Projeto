function [BloomFilter] = CountingFilter(BloomFilter,k,valor)
for i=1:k
    string=[valor num2str(i^5)];
    index=mod(string2hash(string),length(BloomFilter))+1;
    BloomFilter(index)=BloomFilter(index)+1;
end
end