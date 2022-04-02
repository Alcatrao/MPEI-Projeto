%% Uso do counting bloom filter para verificar se um número à escolha é primo
clear;clc;close;
Primos=load('Primos.txt'); %carrega um double só com primos para a variável 'Primos'

k=10; %hash functions
N=length(Primos(:)); %nº de nºs primos

BloomFilter = Bloom_Filter(N*10); %iniciar Bloom Filter
for i=1:N
    BloomFilter = Bloom_Filter_insert(BloomFilter,k,Primos(i));
end %inserir hashes de todos os primos na variável Primos no bloom filter




%..............INSERIR NUMERO PARA VERIFICAR SE É PRIMO...................
numero=1039;
%.........................................................................




Pertence = BloomCount(BloomFilter,k,numero); %Verificar se o valor escolhido foi hasheado para o bloom filter
if Pertence == 0;
    fprintf('%.0f não é um número primo =(\n', numero);
else
    fprintf('%.0f é um número primo\n', numero);
end

falsos=(1-exp(k/N*10))^k; %Probabilidade teórica de nº falsos
%% 
%Contagem de quantas vezes um conjunto de números primos escolhidos ao
%acaso se repete numa matriz de inteiros aleatórios

clc;clear;
Matriz=[randi([1,13000], 1, 10000)]; %matriz de 10000 inteiros aleatórios entre 1 e 13000

k=10; %hash functions
M=length(Matriz(:)); %nº de nºs



%..........INSERIR NUMERO PARA OBTER ESSA QUANTIDADE DE PRIMOS............
numero=7; %nº de nºs primos aleatórios para se observar
%.........................................................................



Primos=load('Primos.txt');
PrimosRandom=Primos(1:130); %limitar a escolha entre os 130 primeiros primos, que eles começam a ficar grandes
PrimosRand=zeros(1,numero); %UserRand vai ter 100 users aleatórios
for n=1:numero
    PrimosRand(n)=PrimosRandom(randi([1,length(PrimosRandom)+1-n])); %retirar user escolhido da lista, e ajustar a indexação da mesma
    a=find(PrimosRandom==PrimosRand(n));
    PrimosRandom(a)=[];
end
PrimosRand=unique(PrimosRand); %Para ordená-los em ordem crescente

BloomFilter = Bloom_Filter(M*10);
BloomFilter = double(BloomFilter); %Converter matriz de bit para double (para fazer somas maiores que 255 e tal)

for i=1:M
    BloomFilter = CountingFilter(BloomFilter,k,Matriz(i));
end

Conta=zeros(1,10);
for i=1:numero
    Conta(i) = BloomCount(BloomFilter,k,PrimosRand(i));
    fprintf(' O número %.0f aparece no Counting Bloom Filter %d vezes\n', PrimosRand(i), Conta(i));
end
for i=1:numero
    fprintf(' De facto, o número %.0f consta %d vezes na matriz aleatória original\n', PrimosRand(i), sum(Matriz==PrimosRand(i)));
end
