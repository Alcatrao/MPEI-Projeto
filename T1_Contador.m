%% 
%Uso do contador estocástico para verificar quantas vezes uma sequência de
%cartas ocorre em 10000000 experiências (tirar uma carta do baralho e
%repô-la)

close; clc; clear;
fid = fopen('cards.txt'); %abre o ficheiro para leitura e retorna um identificador do mesmo
cartas = fscanf(fid,'%c'); %escreve o conteudo do ficheiro identificado nas cartas, de classe 'char'
fclose(fid); %fecha o ficheiro
cards=splitlines(cartas); %separa os conteúdos por células (cada nova linha é uma nova célula)

% cartas=cell(52,2);
% for i=1:52
%     cartas(i,1)={i};
% end
% cartas(:,2)=cards;
cartas=1:52; %nº de cartas

shufle=10000000; %vezes que se repete a experiência
results=randi([1,52], 1, shufle); %resultados
sequence=cell(1); %pre alloc??



%...................ESCREVER SEQUÊNCIA DEEJADA............................
sequence={'Ace of Hearts' 'Ace of Spades' 'Ace of Diamonds'};
%.........................................................................





for j=1:length(cards)
    for i=1:length(sequence)
        a(j,i)=strcmp(sequence{i}, cards{j}); %obter o valor lógico de cada carta
    end
end
for i=1:length(sequence)
    value(i)=cartas(a(:,i)); %sequência das cartas, mas em numérico (para que possa ser tratado com rands() e tal)
end

limit=length(results)*0.5; 
%até onde se procura a sequência nos resultados (neste caso, procura-se só
%na primeira metade dos dados)

[count] = Stochastic(value,results,limit);
verdade=length(strfind(results, value));
fprintf('\n  Estima-se que a sequência que se pretendia obter ocorreu %d vezes \n', count);
fprintf('\n  Na verdade, a sequência ocorreu %d vezes \n', verdade);