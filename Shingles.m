function [Shingles] = Shingles(doc, shingle_size)
  len=length(doc)-shingle_size+1;
  Shingles=cell(1,len);
  for i=1:len
    t='';
    for j=i:(i+shingle_size-2)
      t=strcat(t,doc{j},' ');
    end
    t=strcat(t,doc{i+shingle_size-1});
    Shingles{i}=t;
  end