function [DJaccard,SimilarUsersMinHash] = MinHashstring2hash(Set, itemsH, k, threshold)

Nf=length(itemsH);
Nu=length(Set);

HashFilmes=zeros(Nf,k);
h0=waitbar(0,'Calculating hashes');
for f=1:Nf, waitbar(f/Nf, h0)
    for h=1:k
        key=[f num2str(h^3)];
        HashFilmes(f,h)=string2hash(key);
    end
end
delete(h0);

%d=ismember(itemsH,Set{u1}); %génio

h2=waitbar(0,'Calculating signatures');
SignatureFilmes=zeros(Nu,k);
for u1=1:Nu, waitbar(u1/Nu,h2)
    d=ismember(itemsH,Set{u1});
    SignatureFilmes(u1,:)=min(HashFilmes(d,:));
end
delete(h2);

DJaccard=zeros(Nu);
h1= waitbar(0,'Calculating Jaccard Distances');
for n1=1:Nu, waitbar(n1/Nu,h1);
    for n2=1:Nu
       intersectLength = length(intersect(Set{n1}, Set{n2}));
       unionLength = length(Set{n1}) + length(Set{n2}) - intersectLength;
       DJaccard(n1, n2) = 1 - intersectLength / unionLength;
    end
end
delete(h1);


%Cálculo dos similares

SimilarUsersMinHash= zeros(1,3);
k= 1;
for n1= 1:Nu
    for n2= n1+1:Nu
        if DJaccard(n1,n2)<threshold
            SimilarUsersMinHash(k,:)= [n1 n2 DJaccard(n1,n2)];
            k= k+1;
        end
    end
end

end