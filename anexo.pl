

ocupacaoCritica(HoraInicio, HoraFim, Threshold, Resultados) :-
    
    findall(casosCriticos(DiaSemana, TipoSala, PercentagemArredondada),
            (evento(ID, _, _, _, Sala),
            horario(ID, DiaSemana, _, _, _, Periodo),
            salas(TipoSala, Salas),
            member(Sala, Salas),
            numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras),
            ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max),
            percentagem(SomaHoras, Max, Percentagem),
            Percentagem >= Threshold,
            PercentagemArredondada is ceiling(Percentagem)),
        Resultados).


ocupacaoMesa([maria, joao, pedrito, jorge, ana, manelito, miguel, guga],[cab1(maria), cab2(joao), honra(joao, guga), lado(ana, manelito),lado(miguel, pedrito), frente(miguel, jorge),naoFrente(pedrito, manelito)], L).



evolucaoHorasCurso('leic-t', Evolucao).

horasCurso(p1, 'leic-t', 1, TotalHoras).
horasCurso(p2, 'leic-t', 1, TotalHoras).
horasCurso(p3, 'leic-t', 1, TotalHoras).
horasCurso(p4, 'leic-t', 1, TotalHoras).
horasCurso(p1, 'leic-t', 2, TotalHoras).
horasCurso(p2, 'leic-t', 2, TotalHoras).
horasCurso(p3, 'leic-t', 2, TotalHoras).
horasCurso(p4, 'leic-t', 2, TotalHoras).


numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras)



?- ocupacaoMesa([maria, joao, pedrito, jorge, ana, manelito, miguel, guga],[cab1(maria), cab2(joao), honra(joao, guga), lado(ana, manelito),lado(miguel, pedrito), frente(miguel, jorge),naoFrente(pedrito, manelito)], L).
   L = [[miguel,pedrito,guga],[maria,joao],[jorge,ana,manelito]] ;
   false.
?- ocupacaoMesa([a, b, c, d, e, f, g, h],[cab1(e), honra(e,b), naoFrente(a,b),lado(f,g), lado(a, c), naoLado(f, c), naoFrente(f, c), frente(g, d)], L).
   L = [[c,a,d],[e,h],[b,f,g]] ;
   false.
?- ocupacaoMesa([a, b, c, d, e, f, g, h], [cab1(e), honra(e, b), cab2(c),honra(c, a), naoFrente(a, b), naoLado(b, f), lado(f, g), frente(b, h)], L).
L = [[h,d,a],[e,c],[b,g,f]];
false.

lado(NomePessoa1, NomePessoa2, Permutacao):-
   (nth1(Posicao1, Permutacao, NomePessoa1), nth1(Posicao2, Permutacao, NomePessoa2), 
       Posicao2 is Posicao1 + 1);
   (nth1(Posicao1, Permutacao, NomePessoa1), nth1(Posicao2, Permutacao, NomePessoa2), 
       Posicao2 is Posicao1 - 1).

naoLado(NomePessoa1, NomePessoa2, Permutacao):-
   \+lado(NomePessoa1, NomePessoa2, Permutacao).

   frente(NomePessoa1, NomePessoa2, Permutacao):-
      (nth1(1, Permutacao, NomePessoa1), nth1(6, Permutacao, NomePessoa2));
      (nth1(2, Permutacao, NomePessoa1), nth1(7, Permutacao, NomePessoa2));
      (nth1(3, Permutacao, NomePessoa1), nth1(8, Permutacao, NomePessoa2));
      (nth1(6, Permutacao, NomePessoa1), nth1(1, Permutacao, NomePessoa2));
      (nth1(7, Permutacao, NomePessoa1), nth1(2, Permutacao, NomePessoa2));
      (nth1(8, Permutacao, NomePessoa1), nth1(3, Permutacao, NomePessoa2)).

      numHorasOcupadas(p4, pequenosAnfiteatros, segunda-feira, 8, 12.5, S).
   ocupacaoMax(pequenosAnfiteatros, 8, 12.5, Max).

   percentagem(5.5, 13.5, Percentagem).

   numHorasOcupadas(p4, grandesAnfiteatros, segunda-feira, 8, 12.5, S).
S = 8.5 .

?- numHorasOcupadas(p3, pequenosAnfiteatros, segunda-feira, 8, 12.5, S).
S = 5.5 .

?- numHorasOcupadas(p4, pequenosAnfiteatros, segunda-feira, 8, 12.5, S).
S = 0 .

?- ocupacaoMax(pequenosAnfiteatros, 8, 12.5, Max).
Max = 13.5.

?- percentagem(12.5, 13.5, Percentagem).
Percentagem = 92.5925925925926.

?- percentagem(8.5, 13.5, Percentagem).
Percentagem = 62.96296296296296.

?- percentagem(5.5, 13.5, Percentagem).
Percentagem = 40.74074074074074.

?- 


combinacoes3(ListaTiposSala, ListaDiasSemana, Periodos,  Comb) :-
   findall((TipoSala, DiaSemana, Periodo), (member(TipoSala, ListaTiposSala),
       member(DiaSemana, ListaDiasSemana), member(Periodo, Periodos)), Comb).

ocupacaoCritica(HoraInicio, HoraFim, Threshold, Resultados) :-
   findall(Tipo, salas(Tipo, _), ListaTiposSala),
   ListaDiasSemana = [segunda-feira, terca-feira, quarta-feira, quinta-feira, sexta-feira],
   Periodos = [p1, p2, p3, p4],
   combinacoes3(ListaDiasSemana, ListaTiposSala, Periodos, Comb),
   ocupacaoCritica(HoraInicio, HoraFim, Threshold, Comb, Resultados).
   
ocupacaoCritica(HoraInicio, HoraFim, Threshold, [(DiaSemana, TipoSala, Periodo)|OutrasComb], [(DiaSemana, TipoSala, PercentagemArredondada)|Outras]):-
   evento(ID, _, _, _, TipoSala),
   horario(ID, DiaSemana, _, _, _, Periodo),
   numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras),
   ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max),
   percentagem(SomaHoras, Max, Percentagem),
   Percentagem > Threshold,
   PercentagemArredondada is ceiling(Percentagem),
   ocupacaoCritica(HoraInicio, HoraFim, Threshold, OutrasComb, Outras).

ocupacaoCritica(_,_,_,[],[]).




ocupacaoCritica(HoraInicio, HoraFim, Threshold, Resultados) :-
   findall(casosCriticos(DiaSemana, TipoSala, PercentagemArredondada),
       (evento(ID, _, _, _, Sala),
       horario(ID, DiaSemana, _, _, _, Periodo),
       salas(TipoSala, Salas),
       member(Sala, Salas),
       numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras),
       ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max),
       percentagem(SomaHoras, Max, Percentagem),
       Percentagem > Threshold,
       PercentagemArredondada is ceiling(Percentagem)),
       ResultadosRepetidos),
   sort(ResultadosRepetidos, Resultados).