% 99528 Mariana Mendonca

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % para listas completas
:- ['dados.pl'], ['keywords.pl']. % ficheiros a importar.

% ------------------------------------------------------------------------------
% eventosSemSalas(EventosSemSala)
% e verdade se EventosSemSala e uma lista, ordenada e sem elementos repetidos, 
% de IDs de eventos sem sala
% ------------------------------------------------------------------------------

eventosSemSalas(EventosSemSala) :-
    findall(ID, evento(ID, _, _, _, semSala), Eventos),
    sort(Eventos, EventosSemSala).

% ------------------------------------------------------------------------------
% eventosSemSalas(DiaDaSemana, EventosSemSala)
% e verdade se EventosSemSala e uma lista, ordenada e sem elementos repetidos, 
% de IDs de eventos sem sala que decorrem em DiaDaSemana (doravante 
% segunda-feira, terca-feira, quarta-feira, quinta-feira, sexta-feira, sabado)
% ------------------------------------------------------------------------------

eventosSemSalasDiaSemana(DiaDaSemana, EventosSemSala) :-
    findall(ID, (evento(ID, _, _, _, semSala), 
        horario(ID, DiaDaSemana, _, _, _, _)), Eventos),
    sort(Eventos, EventosSemSala).

% ------------------------------------------------------------------------------
% adicionaSemestre(ListaPeriodos, NovaListaPeriodos)
% adiciona o semestre correspondente a lista de periodos
% ------------------------------------------------------------------------------

adicionaSemestre(ListaPeriodos, NovaListaPeriodos) :-
  (member(p1, ListaPeriodos); member(p2, ListaPeriodos)),
  (member(p3, ListaPeriodos); member(p4, ListaPeriodos)),
  append([p1_2, p3_4], ListaPeriodos, NovaListaPeriodos).

adicionaSemestre(ListaPeriodos, NovaListaPeriodos) :-
  (member(p1, ListaPeriodos); member(p2, ListaPeriodos)),
  \+ (member(p3, ListaPeriodos); member(p4, ListaPeriodos)),
  append([p1_2], ListaPeriodos, NovaListaPeriodos).

adicionaSemestre(ListaPeriodos, NovaListaPeriodos) :-
  (member(p3, ListaPeriodos); member(p4, ListaPeriodos)),
  \+ (member(p1, ListaPeriodos); member(p2, ListaPeriodos)),
  append([p3_4], ListaPeriodos, NovaListaPeriodos).

adicionaSemestre(ListaPeriodos, NovaListaPeriodos) :-
  NovaListaPeriodos = ListaPeriodos.

% ------------------------------------------------------------------------------
% eventosSemSalas(ListaPeriodos, EventosSemSala)
% e verdade se ListaPeriodos e uma lista de periodos e EventosSemSala e uma 
% lista, ordenada e sem elementos repetidos, de IDs de eventos sem sala nos 
% periodos de ListaPeriodos.
% ------------------------------------------------------------------------------

eventosSemSalasPeriodo(ListaPeriodos, EventosSemSala) :-
    
    adicionaSemestre(ListaPeriodos, NovaListaPeriodos),
    findall(ID, (evento(ID, _, _, _, semSala),
    horario(ID, _, _, _, _, Periodo), member(Periodo, NovaListaPeriodos)), 
    Eventos),
    sort(Eventos, EventosSemSala).

% ------------------------------------------------------------------------------
% organizaEventos(ListaEventos, Periodo, EventosNoPeriodo) 
% e verdade se EventosNoPeriodo e a lista, ordenada e sem elementos repetidos,
% de IDs dos eventos de ListaEventos que ocorrem no periodo Periodo
% ------------------------------------------------------------------------------

organizaEventos(Eventos, Periodo, EventosOrdenados) :-
    organizaEventosAux(Eventos, Periodo, EventosNoPeriodo),
    sort(EventosNoPeriodo, EventosOrdenados).

organizaEventosAux([], _, []).

organizaEventosAux([Evento|Outros], Periodo, [Evento|EventosNoPeriodo]) :-
    adicionaSemestre([Periodo], NovaListaPeriodos),
    (horario(Evento, _, _, _, _, PeriodoEvento), member(PeriodoEvento, NovaListaPeriodos)),
    organizaEventosAux(Outros, Periodo, EventosNoPeriodo).

organizaEventosAux([_|Outros], Periodo, EventosNoPeriodo) :-
    organizaEventosAux(Outros, Periodo, EventosNoPeriodo).

% ------------------------------------------------------------------------------
% eventosMenoresQue(Duracao, ListaEventosMenoresQue) 
% e verdade se ListaEventosMenoresQue e a lista ordenada e sem elementos 
% repetidos dos identificadores dos eventos que tem duracao menor ou igual a
% Duracao.
% ------------------------------------------------------------------------------

eventosMenoresQue(Duracao, EventosMenoresQue) :-
    findall(ID, (horario(ID, _, _, _, DuracaoEvento, _), 
        DuracaoEvento =< Duracao), Eventos),
    sort(Eventos, EventosMenoresQue).

% ------------------------------------------------------------------------------
% eventosMenoresQueBool(ID, Duracao) e
% e verdade se o evento identificado por ID tiver duracao igual ou menor a 
% Duracao.
% ------------------------------------------------------------------------------

eventosMenoresQueBool(ID, Duracao) :-
    horario(ID, _, _, _,  DuracaoEvento, _),
    DuracaoEvento =< Duracao.

% ------------------------------------------------------------------------------
% procuraDisciplinas(Curso, ListaDisciplinas) 
% e verdade se ListaDisciplinas e a lista ordenada alfabeticamente do nome das 
% disciplinas do curso Curso.
% ------------------------------------------------------------------------------

procuraDisciplinas(Curso, ListaDisciplinas):-
    findall(Disciplina, (evento(ID, Disciplina, _, _, _), 
        turno(ID, Curso, _, _)), Disciplinas),
        sort(Disciplinas, ListaDisciplinas).

% ------------------------------------------------------------------------------
% todosMembros(Curso, ListaDisciplinas)
% e verdade se todas as disciplinas presentes em ListaDisciplinas pertencerem a 
% lista de disciplinas do curso Curso geradas atraves do predicado 
% procuraDisciplinas(Curso, ListaDisciplinas).
% ------------------------------------------------------------------------------

todosMembros(_, []).
todosMembros(Curso, [Disciplina | Outras]) :-
    procuraDisciplinas(Curso, Disciplinas),
    member(Disciplina, Disciplinas),
    todosMembros(Curso, Outras).

% ------------------------------------------------------------------------------
% organizaDisciplinas(ListaDisciplinas, Curso, Semestres)
% e verdade se Semestres e uma lista com duas listas. A lista na primeira 
% posicao contem as disciplinas de ListaDisciplinas do curso Curso que ocorrem 
% no primeiro semestre; idem para a lista na segunda posicao, que contem as que 
% ocorrem no segundo semestre. Ambas as listas devem estar ordenadas 
% alfabeticamente e nao devem ter elementos repetidos. O predicado falha se nao 
% existir no curso Curso uma disciplina de ListaDisciplinas. Pode-se assumir que 
% nao existem disciplinas anuais.
% ------------------------------------------------------------------------------

organizaDisciplinas(ListaDisciplinas, Curso, Semestres) :-
    todosMembros(Curso, ListaDisciplinas),
    organizaDisciplinas(ListaDisciplinas, Curso, [], [], Semestres).

organizaDisciplinas([], _, Sem1, Sem2, [Sem1Ordenado, Sem2Ordenado]):-
    sort(Sem1, Sem1Ordenado),
    sort(Sem2, Sem2Ordenado).

organizaDisciplinas([Disciplina|Outras], Curso, Sem1, Sem2, Semestres) :-

    ((evento(ID, Disciplina, _, _, _), turno(ID, Curso, _, _)),
    (horario(ID, _, _, _, _, Periodo), member(Periodo, [p1, p2, p1_2])))
    -> organizaDisciplinas(Outras, Curso, [Disciplina|Sem1], Sem2, Semestres);

    ((evento(ID, Disciplina, _, _, _), turno(ID, Curso, _, _)),
    (horario(ID, _, _, _, _, Periodo), member(Periodo, [p3, p4, p3_4])))
    -> organizaDisciplinas(Outras, Curso, Sem1, [Disciplina|Sem2], Semestres).

organizaDisciplinas([_|Outras], Curso, Sem1, Sem2, Semestres) :-
    organizaDisciplinas(Outras, Curso, Sem1, Sem2, Semestres).


% ------------------------------------------------------------------------------
% horasCurso(Periodo, Curso, Ano, TotalHoras) 
% e verdade se TotalHoras for o numero de horas total dos eventos associadas ao
% curso Curso, no ano Ano e periodo Periodo.
% ------------------------------------------------------------------------------

horasCurso(Periodo, Curso, Ano, TotalHoras) :-
    adicionaSemestre([Periodo], NovaListaPeriodos),
    findall(ID, (horario(ID, _, _, _, Duracao, PeriodoEvento), member(PeriodoEvento, NovaListaPeriodos),
        turno(ID, Curso, Ano, _)), Eventos),
    sort(Eventos, EventosSemRepetidos),
    (EventosSemRepetidos == [] -> TotalHoras = 0; 

    findall(Duracao, (member(ID, EventosSemRepetidos),horario(ID, _, _, _, Duracao,_)), Duracoes),
    sumlist(Duracoes, TotalHoras)).
% ------------------------------------------------------------------------------
% combinacoes(Anos, Periodos, Comb)
% e verdade se Comb e uma lista de tuplos na forma (Ano, Periodo) que representa
% todas as combinacoes entre os elementos das listas Anos e Periodos
% ------------------------------------------------------------------------------

combinacoes(Anos, Periodos, Comb) :-
    findall((Ano, Periodo), (member(Ano, Anos), member(Periodo, Periodos)), Comb).

% ------------------------------------------------------------------------------
% evolucaoHorasCurso(Curso, Evolucao)
% e verdade se Evolucao for uma lista de tuplos na forma (Ano, Periodo, 
% NumHoras), em que NumHoras e o total de horas associadas ao curso Curso, no 
% ano Ano e periodo Periodo. Evolucao devera estar ordenada por ano (crescente)
% e periodo.
% ------------------------------------------------------------------------------

evolucaoHorasCurso(Curso, Evolucao) :-
    combinacoes([1, 2, 3], [p1, p2, p3, p4], Comb),
    evolucaoHorasCurso(Curso, Comb, Evolucao).

evolucaoHorasCurso(Curso, [(Ano, Periodo)|OutrasComb], [(Ano, Periodo, NumHoras)|Outras]):-
    horasCurso(Periodo, Curso, Ano, NumHoras),
    evolucaoHorasCurso(Curso, OutrasComb, Outras).

evolucaoHorasCurso(_,[], []).

% ------------------------------------------------------------------------------
% ocupaSlot(HoraInicioDada, HoraFimDada, HoraInicioEvento, HoraFimEvento, Horas)
% e verdade se Horas for o numero de horas sobrepostas entre o evento que tem 
% inicio em HoraInicioEvento e fim em HoraFimEvento, e o slot que tem inicio em
% HoraInicioDada e fim em HoraFimDada. Se nao existirem sobreposicoes o 
% predicado deve falhar.
% ------------------------------------------------------------------------------

ocupaSlot(HoraInicioDada, HoraFimDada, HoraInicioEvento, HoraFimEvento, Horas) :-

    HoraFimEvento > HoraInicioDada, 
    HoraFimDada > HoraInicioEvento,
    Horas is 
        min(HoraFimDada, HoraFimEvento) - max(HoraInicioDada, HoraInicioEvento).

% ------------------------------------------------------------------------------
% numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras)
% e verdade se SomaHoras for o numero de horas ocupadas nas salas do tipo 
% TipoSala, no intervalo de tempo definido entre HoraInicio e HoraFim, no dia 
% da semana DiaSemana, e no periodo Periodo.
% ------------------------------------------------------------------------------

numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras):-

    adicionaSemestre([Periodo], NovaListaPeriodos),
    salas(TipoSala, ListaSalas), 

    findall(Horas, 
        (evento(ID, _, _, _, Sala), member(Sala, ListaSalas),
        horario(ID, DiaSemana, HoraInicioEvento, HoraFimEvento, _, PeriodoEvento), 
        member(PeriodoEvento, NovaListaPeriodos),
        ocupaSlot(HoraInicio, HoraFim, HoraInicioEvento, HoraFimEvento, Horas)),
    TotalHoras),

    sumlist(TotalHoras, SomaHoras).

% ------------------------------------------------------------------------------
% ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max) 
% e verdade se Max for o numero de horas possiveis de ser ocupadas por salas do
% tipo TipoSala, no intervalo de tempo definido entre HoraInicio e HoraFim.
% ------------------------------------------------------------------------------
    
ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max) :-
    salas(TipoSala, ListaSalas),
    length(ListaSalas, NumSalas),
    
    Intervalo is HoraFim - HoraInicio,
    Max is Intervalo * NumSalas.

% ------------------------------------------------------------------------------
% percentagem(SomaHoras, Max, Percentagem) 
% e verdade se Percentagem for a divisao de SomaHoras por Max, multiplicada por
% 100.
% ------------------------------------------------------------------------------

percentagem(SomaHoras, Max, Percentagem):-
    Percentagem is (SomaHoras / Max) * 100.

% ------------------------------------------------------------------------------
% ocupacaoCritica(HoraInicio, HoraFim, Threshold, Resultados)
% e verdade se Resultados for uma lista ordenada de tuplos do tipo 
% casosCriticos(DiaSemana, TipoSala, Percentagem) em que DiaSemana, TipoSala e
% Percentagem sao, respectivamente, um dia da semana, um tipo de sala e a sua 
% percentagem de ocupacao, no intervalo de tempo entre HoraInicio e HoraFim, e 
% supondo que a percentagem de ocupacao relativa a esses elementos esta acima
% de um dado valor critico (Threshold). Na representacao do tuplo, usa o 
% predicado ceiling para arredondar para o proximo inteiro o valor da
% percentagem, isto e Percentagem deve ser o primeiro maior inteiro relativo 
% ao valor da percentagem usado nos calculos (mas apenas na representacao do 
% tuplo; nos calculos deve usar o valor da percentagem sem qualquer 
% arredondamento).
% ------------------------------------------------------------------------------

ocupacaoCritica(HoraInicio, HoraFim, Threshold, Resultados) :-
    findall(casosCriticos(DiaSemana, TipoSala, PercentagemArredondada),
        (evento(ID, _, _, _, Sala),
        horario(ID, DiaSemana, _, _, _, Periodo),
        salas(TipoSala, Salas),
        member(Sala, Salas),
        \+ member(Periodo, [p1_2, p3_4]),
        numHorasOcupadas(Periodo, TipoSala, DiaSemana, HoraInicio, HoraFim, SomaHoras),
        ocupacaoMax(TipoSala, HoraInicio, HoraFim, Max),
        percentagem(SomaHoras, Max, Percentagem),
        Percentagem > Threshold,
        PercentagemArredondada is ceiling(Percentagem)),
        ResultadosRepetidos),
    sort(ResultadosRepetidos, Resultados).

% ------------------------------------------------------------------------------
% ocupacaoMesa(ListaPessoas, ListaRestricoes, OcupacaoMesa)
% ------------------------------------------------------------------------------

cab1(NomePessoa, Permutacao):-
    nth1(4, Permutacao, NomePessoa).

cab2(NomePessoa, Permutacao):-
    nth1(5, Permutacao, NomePessoa).

honra(NomePessoa1, NomePessoa2, Permutacao):-
    (nth1(5, Permutacao, NomePessoa1), nth1(3, Permutacao, NomePessoa2));
    (nth1(4, Permutacao, NomePessoa1), nth1(6, Permutacao, NomePessoa2)).

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

naoFrente(NomePessoa1, NomePessoa2, Permutacao):-
    \+frente(NomePessoa1, NomePessoa2, Permutacao).

restricoes([], _).
restricoes([Restricao|Restricoes], Permutacao):-
    call(Restricao, Permutacao),
    restricoes(Restricoes, Permutacao).

separar([X1, X2, X3, X4, X5, X6, X7, X8], OcupacaoMesa):-
    OcupacaoMesa = [[X1, X2, X3], [X4, X5], [X6, X7, X8]].

ocupacaoMesa(ListaPessoas, ListaRestricoes, OcupacaoMesa):-
    permutation(ListaPessoas, Permutacao),
    restricoes(ListaRestricoes, Permutacao),
    separar(Permutacao, OcupacaoMesa).




    