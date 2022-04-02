%% Uso do counting bloom filter para verificar se um n�mero � escolha � primo
clear;clc;close;
Primos=load('Primos.txt'); %carrega um double s� com primos para a vari�vel 'Primos'

k=10; %hash functions
N=length(Primos(:)); %n� de n�s primos

BloomFilter = Bloom_Filter(N*10); %iniciar Bloom Filter
for i=1:N
    BloomFilter = Bloom_Filter_insert(BloomFilter,k,Primos(i));
end %inserir hashes de todos os primos na vari�vel Primos no bloom filter




%..............INSERIR NUMERO PARA VERIFICAR SE � PRIMO...................
numero=1039;
%.........................................................................




Pertence = BloomCount(BloomFilter,k,numero); %Verificar se o valor escolhido foi hasheado para o bloom filter
if Pertence == 0;
    fprintf('%.0f n�o � um n�mero primo =(\n', numero);
else
    fprintf('%.0f � um n�mero primo\n', numero);
end

falsos=(1-exp(k/N*10))^k; %Probabilidade te�rica de n� falsos
%% 
%Contagem de quantas vezes um conjunto de n�meros primos escolhidos ao
%acaso se repete numa matriz de inteiros aleat�rios

clc;clear;
Matriz=[randi([1,13000], 1, 10000)]; %matriz de 10000 inteiros aleat�rios entre 1 e 13000

k=10; %hash functions
M=length(Matriz(:)); %n� de n�s



%..........INSERIR NUMERO PARA OBTER ESSA QUANTIDADE DE PRIMOS............
numero=7; %n� de n�s primos aleat�rios para se observar
%.........................................................................



Primos=load('Primos.txt');
PrimosRandom=Primos(1:130); %limitar a escolha entre os 130 primeiros primos, que eles come�am a ficar grandes
PrimosRand=zeros(1,numero); %UserRand vai ter 100 users aleat�rios
for n=1:numero
    PrimosRand(n)=PrimosRandom(randi([1,length(PrimosRandom)+1-n])); %retirar user escolhido da lista, e ajustar a indexa��o da mesma
    a=find(PrimosRandom==PrimosRand(n));
    PrimosRandom(a)=[];
end
PrimosRand=unique(PrimosRand); %Para orden�-los em ordem crescente

BloomFilter = Bloom_Filter(M*10);
BloomFilter = double(BloomFilter); %Converter matriz de bit para double (para fazer somas maiores que 255 e tal)

for i=1:M
    BloomFilter = CountingFilter(BloomFilter,k,Matriz(i));
end

Conta=zeros(1,10);
for i=1:numero
    Conta(i) = BloomCount(BloomFilter,k,PrimosRand(i));
    fprintf(' O n�mero %.0f aparece no Counting Bloom Filter %d vezes\n', PrimosRand(i), Conta(i));
end
for i=1:numero
    fprintf(' De facto, o n�mero %.0f consta %d vezes na matriz aleat�ria original\n', PrimosRand(i), sum(Matriz==PrimosRand(i)));
end
