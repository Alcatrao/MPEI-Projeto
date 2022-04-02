%% 
%Uso do contador estoc�stico para verificar quantas vezes uma sequ�ncia de
%cartas ocorre em 10000000 experi�ncias (tirar uma carta do baralho e
%rep�-la)

close; clc; clear;
fid = fopen('cards.txt'); %abre o ficheiro para leitura e retorna um identificador do mesmo
cartas = fscanf(fid,'%c'); %escreve o conteudo do ficheiro identificado nas cartas, de classe 'char'
fclose(fid); %fecha o ficheiro
cards=splitlines(cartas); %separa os conte�dos por c�lulas (cada nova linha � uma nova c�lula)

% cartas=cell(52,2);
% for i=1:52
%     cartas(i,1)={i};
% end
% cartas(:,2)=cards;
cartas=1:52; %n� de cartas

shufle=10000000; %vezes que se repete a experi�ncia
results=randi([1,52], 1, shufle); %resultados
sequence=cell(1); %pre alloc??



%...................ESCREVER SEQU�NCIA DEEJADA............................
sequence={'Ace of Hearts' 'Ace of Spades' 'Ace of Diamonds'};
%.........................................................................





for j=1:length(cards)
    for i=1:length(sequence)
        a(j,i)=strcmp(sequence{i}, cards{j}); %obter o valor l�gico de cada carta
    end
end
for i=1:length(sequence)
    value(i)=cartas(a(:,i)); %sequ�ncia das cartas, mas em num�rico (para que possa ser tratado com rands() e tal)
end

limit=length(results)*0.5; 
%at� onde se procura a sequ�ncia nos resultados (neste caso, procura-se s�
%na primeira metade dos dados)

[count] = Stochastic(value,results,limit);
verdade=length(strfind(results, value));
fprintf('\n  Estima-se que a sequ�ncia que se pretendia obter ocorreu %d vezes \n', count);
fprintf('\n  Na verdade, a sequ�ncia ocorreu %d vezes \n', verdade);