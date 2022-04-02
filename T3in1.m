%Uso do contador estocástico e do counting bloom filter para determinar se
%uma determinada frase é dita (e quantas vezes o é) em cada um dos três
%primeiros filmes do Harry Potter.

%De seguida, calcula-se a similaridade entre os filmes em que a frase é
%dita através de MinHashing.

clear;clc;close all;
directory = 'Legendas';
files = dir(fullfile(directory, '*.txt')); %contruir path dos ficheiros de interesse
nfiles = length(files); %quantidade de ficheiros de interesse
data = cell(nfiles,1); %célula para guardar os ficheiros
for i = 1:nfiles
    fid = fopen( fullfile(directory, files(i).name) ); %abrir os ficheiros para leitura
    data{i} = fscanf(fid,'%c'); %e escrevê-los na devida célula 
    fclose(fid); %fechar ficheiro
end
for i=1:nfiles
    data{i}=lower(data{i}); %dar lowercase a todas as letras, para que não hajam falsas diferenças
end


%Usar só 3 legendas, por motivos de estatística
HP1=strsplit(data{1},{'\n',' ', '.'}); % separar a informação usando espaços, pontos e vírgulas
HP2=strsplit(data{2},{'\n',' ', '.'});
HP3=strsplit(data{3},{'\n',' ', '.'});


shingle_size=3; %tamanho da shingle
sHP1 = Shingles(HP1, shingle_size); %compôr legendas por shingles, em vez de palavras soltas
sHP2 = Shingles(HP2, shingle_size);
sHP3 = Shingles(HP3, shingle_size);
sHP1=sHP1(1:6000); %cobre-se só cerca de metade das shingles, para poupar algum tempo a custo de eficiência
sHP2=sHP2(1:6000);
sHP3=sHP3(1:6000);

k=10; %hash functions
BloomFilterHP1=double(Bloom_Filter(length(HP1)*5)); %iniciar bloom filters para inserir hashes das shingles
for i=1:length(sHP1)
    BloomFilterHP1=CountingFilter(BloomFilterHP1,k,sHP1{i});
end
BloomFilterHP2=double(Bloom_Filter(length(HP2)*5)); %e utilizar
for i=1:length(sHP2)
    BloomFilterHP2=CountingFilter(BloomFilterHP2,k,sHP2{i});
end
BloomFilterHP3=double(Bloom_Filter(length(HP3)*5));
for i=1:length(sHP3)
    BloomFilterHP3=CountingFilter(BloomFilterHP3,k,sHP3{i});
end


frase='Witchcraft and Wizardry'; % <----------- QUOTE a pesquisar nas legendas


quote=strsplit(lower(frase), ' '); %lowercase
squote=Shingles(quote, shingle_size); %o quote tem de ter um nº de palavras igual ou maior a shingle_size

number(1) = BloomCount(BloomFilterHP1,k,squote{1}); %counting bloom filters
number(2) = BloomCount(BloomFilterHP2,k,squote{1});
number(3) = BloomCount(BloomFilterHP3,k,squote{1});

Pertence(1) = BloomVerify(BloomFilterHP1,k,squote{1}); %condição de pertença; 
Pertence(2) = BloomVerify(BloomFilterHP2,k,squote{1}); %informa de modo probabilístico se um elemento
Pertence(3) = BloomVerify(BloomFilterHP3,k,squote{1}); %pertence ao conjunto ou não

for i=1:k
quotehash1(i)=mod(string2hash([squote{1} num2str(i^5)]),length(HP1)*5)+1; %hashear o quote
BF1=find(BloomFilterHP1>0); %e inseri-lo no bloom filter de cada legenda
limit=round(length(BF1)/1);
count(1,i)=round(Stochastic(quotehash1(i),BF1,limit)); %uso de contador estocástico
end

for i=1:k
quotehash2(i)=mod(string2hash([squote{1} num2str(i^5)]),length(HP2)*5)+1;
BF2=find(BloomFilterHP2>0);
limit=round(length(BF2)/1);
count(2,i)=round(Stochastic(quotehash2(i),BF2,limit));
end

for i=1:k
quotehash3(i)=mod(string2hash([squote{1} num2str(i^5)]),length(HP3)*5)+1;
BF3=find(BloomFilterHP3>0);
limit=round(length(BF3)/1);
count(3,i)=round(Stochastic(quotehash3(i),BF3,limit));
end



fprintf('\n  A frase %s aparece:\n', char(frase));
fprintf('%d vezes no %dº filme (counting bloom filter) \n', number(1), 1);
fprintf('%d vezes no %dº filme (counting bloom filter) \n', number(2), 2);
fprintf('%d vezes no %dº filme (counting bloom filter) \n', number(3), 3);

fprintf('\n  A frase %s aparece:\n', char(frase));
fprintf('%d vezes no %dº filme (contador estocástico) \n', min(count(1,:)), 1);
fprintf('%d vezes no %dº filme (contador estocástico) \n', min(count(2,:)), 2);
fprintf('%d vezes no %dº filme (contador estocástico) \n', min(count(3,:)), 3);

fprintf('\n  A frase %s aparece:\n', char(frase));
fprintf('2 vezes no 1º filme (de facto) \n');
fprintf('1 vezes no 2º filme (de facto) \n');
fprintf('0 vezes no 3º filme (de facto) \n\n');





items=unique([sHP1 sHP2]); %juntar todas as shingles (ignorando repetições)
dados=[sHP1; sHP2]; %juntar as 2 legendas (as suas shingles mais concretamente)

itemsH=double(zeros(1,length(items))); %hashear as shingles
for i=1:length(items)
    itemsH(i)=string2hash(items{i});
end

dadosH=double(zeros(2,length(dados))); %hashear as legendas (shingle a shingle)
for j=1:length(dados)
    dadosH(1,j)=string2hash(sHP1{j});
    dadosH(2,j)=string2hash(sHP2{j});
end

Nu=2; %nº de filmes
Set= cell(Nu,1); %pre alloc
for n = 1:Nu
    Set{n} = [Set{n} dadosH(n,:)]; %Set dos dados para serem inseridos na função de MinHash
end




k=50; %hash functions
threshold=1; %limiar similaridade
[~,Similares] = MinHashstring2hash(Set, itemsH, k, threshold);

fprintf('\n Os filmes apresentam uma similaridade (d. Jaccard; usando MinHashing) de %.4f', Similares(3));

%% Proof
N=length(Set);
similarT=zeros(floor(N*(N-1))/2,3);
for n1=1
    for n2=2
            a=unique([sHP1, sHP2]);
            b=intersect(sHP1, sHP2); %Cálculo da similaridade pela fórmula teórica
            c=1-length(b)/length(a);
            similarT(1,:)= [n1 n2 c];
    end
end

fprintf('\n Os filmes apresentam uma similaridade (d. Jaccard; fórmula teórica) de %.4f', similarT(3));