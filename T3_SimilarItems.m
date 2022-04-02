%% 
%C�lculo da similaridade (usando a dist�ncia de Jaccard como medida e o
%MinHashing como m�todo) entre v�rios produtos de beleza

clc; clear; close all;

directory = 'Produtos Beleza';
files = dir(fullfile(directory, '*.txt')); %contruir path dos ficheiros de interesse
nfiles = length(files); %quantidade de ficheiros de interesse
data = cell(nfiles,1); %c�lula para guardar os ficheiros
for i = 1:nfiles
    fid = fopen( fullfile(directory, files(i).name) ); %abrir os ficheiros para leitura
    data{i} = fscanf(fid,'%c'); %e escrev�-los na devida c�lula 
    fclose(fid); %fechar ficheiro
end

names = cell(nfiles,1);
for i = 1:nfiles
    names{i} = files(i).name; %c�lula que guarda o nome de cada produto
end
for i=1:nfiles
    a=length(names{i});
    names{i}=names{i}(1:a-4); %tirar as �ltimas 4 letras ('.txt') dos nomes
end

ingredients=cell(nfiles,1); %dar store dos componentes de cada produto numa c�lula
for i=1:nfiles
    ingredients{i}=strsplit(data{i}, ', '); %separar os componentes por espa�os e v�rgulas
    ingredients{i}=lower(ingredients{i}); %dar lowercase a todas as letras, para que n�o hajam falsas diferen�as
end

products=cell(nfiles,2);
products(:,1)=names; %organizar a informa��o
products(:,2)=ingredients;

%AllProducts=[products{1,2}];
%for i=2:nfiles
%    AllProducts=[AllProducts, products{i,2}];
%end
%AllProducts=unique(AllProducts);

SetNun=cell(nfiles,1);
for i=1:nfiles
    Set=products{i,2};
    list=zeros(1,length(Set)); %converter as componentes em hashes num�ricas, para que possam ser matematicadas 
    for j=1:length(Set)
        %list(j)=mod(string2hash(Set{j}), nfiles*1000)+1;
        list(j)=string2hash(Set{j});
    end
    SetNun{i}=list;
end

k=10000; %hash functions
threshold=1; %limiar similaridade
[~,SimilarUsers] = T3MinHash(SetNun, k, nfiles, threshold);

[~,idx] = sort(SimilarUsers(:,3));
sortedmat = SimilarUsers(idx,:);

n=3; %Top 3 itens similares
similar=sortedmat(1:n,:);




fprintf('\n  Os %d pares de produtos mais similares s�o:\n', n);
for i=1:length(similar)
    fprintf('\n%s\n%s\n Similaridade (D.Jaccard; MinHash) = %f\n', char(products(similar(i,1))), char(products(similar(i,2))), similar(i,3));
end

%% Proof
similarT=zeros(floor(nfiles*(nfiles-1))/2,3);
k=1;
for n1= 1:nfiles,
    for n2= n1+1:nfiles,
            a=unique([products{n1,2} products{n2,2}]);
            b=intersect(products{n1,2}, products{n2,2}); %Similaridade pela f�rmula te�rica
            c=1-length(b)/length(a);
            similarT(k,:)= [n1 n2 c];
            k=k+1;
    end
end
[~,idx] = sort(similarT(:,3)); %organizar os produtos por ordem de semelhan�a
sortedmat = similarT(idx,:);
similaresT=sortedmat(1:5,:);

fprintf('\n  Os %d pares de produtos mais similares pela f�rmula te�rica (sem usar MinHash) s�o:\n', n);
for i=1:length(similar)
    fprintf('\n%s\n%s\n Similaridade (D.Jaccard) = %f\n', char(products(similaresT(i,1))), char(products(similaresT(i,2))), similaresT(i,3));
end