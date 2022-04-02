function [number] = BloomCount(BloomFilter,k,item)
%k - hash functions
%item - item a analisar
%BloomFilter - .

count=zeros(1,k);

for i=1:k
    string=[item num2str(i^5)];               
    index=mod(string2hash(string),length(BloomFilter))+1;
    count(i)=BloomFilter(index);
end
number=min(count);

end

