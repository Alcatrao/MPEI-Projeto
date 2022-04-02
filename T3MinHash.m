function [J, SimilarUsersMinHash] = T3MinHash(Set, k, N, threshold)

%C�lculo das dist�ncias de Jaccard

%J - dist�ncias de Jaccard
%SimilarUsersMinHash - c�lculo da similaridade

%Set - conjunto a ser analisado
%k - n� hash functions
%N - n� de itens a considerar
%threshold - limiar de similaridade

names=1:N; %- ind�ces dos itens a considerar


J=zeros(N,k);
prime=1039;
a=randi([1,prime],1,k);
b=randi([1,prime],1,k);
h0=waitbar(0,'Calculating Jaccard Distances (MinHash)');
for n1=1:N, waitbar(n1/N,h0,sprintf('Calculating Jaccard Distances (MinHash)\n%.1f%%', (n1/N)*100));
    array=Set{n1};
    for h=1:k
        min=mod((a(h)*array(1)+b(h)),prime);
        for j=2:length(array(:))
            temp=mod((a(h)*array(j)+b(h)),prime);  
            if temp<min
               min=temp;
            end
        end
        J(n1,h)=min;
    end 
end
delete(h0);


%C�lculo dos similares
SimilarUsersMinHash=zeros(1,3);
k1=1;
for i=1:N
    for j=i+1:N
        similarity=1-sum(J(i,:)==J(j,:))/k;
        if similarity<threshold
           SimilarUsersMinHash(k1,:)= [names(i) names(j) similarity];
           k1=k1+1;
        end
    end
end
end